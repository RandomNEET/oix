--!nonstrict
local service = noctalia.getConfig("service")
local user = noctalia.getConfig("user")
-- Restrict input before inserting it into a shell command; quote it as well.
local valid = type(service) == "string" and service:match("^[%w_@.:%-]+$") ~= nil
    and service:sub(1, 1) ~= "-"
if valid and not service:match("%.service$") then
    service = service .. ".service"
end
local base = "systemctl " .. (user and "--user " or "")
local querying = false
local busy = false
local properties = {}
local queryError = nil
local operationError = nil

local function render()
    local active = properties.ActiveState or "unknown"
    local transitioning = active == "activating" or active == "deactivating" or active == "reloading"
    local failed = not valid or active == "failed" or properties.LoadState == "not-found" or queryError ~= nil
    barWidget.setGlyph(noctalia.getConfig("glyph"))
    barWidget.setText("")
    local color = (failed or operationError) and "error"
        or (busy or transitioning) and "secondary"
        or active == "active" and "primary" or "on_surface_variant"
    barWidget.setColor(color)
    barWidget.setGlyphColor(color)
    if not valid then
        barWidget.setTooltip("Invalid systemd service name")
        return
    end
    local tooltip = service .. (user and " (user)" or " (system)")
        .. "\n" .. (properties.Description or "")
        .. "\nState: " .. active .. " / " .. (properties.SubState or "unknown")
        .. "\nLoaded: " .. (properties.LoadState or "unknown")
        .. "\nEnabled: " .. (properties.UnitFileState or "unknown")
        .. "\n" .. (busy and "Changing service state…" or "Click to start/stop")
    if queryError then tooltip = tooltip .. "\n" .. queryError end
    if operationError then tooltip = tooltip .. "\n" .. operationError end
    barWidget.setTooltip(tooltip)
end

local function refresh(after)
    if not valid or querying then return end
    querying = true
    local started = noctalia.runAsync(base .. "show --no-pager "
        .. "--property=LoadState,ActiveState,SubState,UnitFileState,Description -- '" .. service .. "'",
        function(result)
            querying = false
            properties = {}
            for key, value in result.stdout:gmatch("([%w]+)=([^\n]*)") do
                properties[key] = value
            end
            queryError = result.exitCode ~= 0 and (result.stderr ~= "" and result.stderr or "Status query failed") or nil
            render()
            if after then after() end
        end, 5000)
    if not started then
        querying = false
        queryError = "Could not launch systemctl"
        render()
    end
end

function update()
    noctalia.setUpdateInterval(noctalia.getConfig("interval") * 1000)
    if not busy then refresh() end
end

function onHover(entered)
    if entered and not busy then refresh() end
end

function onClick()
    if not valid or busy or querying then return end
    -- Recheck before acting, including changes made outside Noctalia.
    refresh(function()
        if queryError or properties.LoadState ~= "loaded" then return end
        local active = properties.ActiveState
        local action = (active == "active" or active == "activating" or active == "reloading") and "stop" or "start"
        busy = true
        operationError = nil
        render()
        local command = (user and "" or "pkexec ") .. base .. action .. " -- '" .. service .. "'"
        local started = noctalia.runAsync(command, function(result)
            busy = false
            if result.exitCode ~= 0 then
                operationError = result.stderr ~= "" and result.stderr or "Service operation failed or was cancelled"
                noctalia.notify(service, operationError)
            else
                noctalia.notify(service, action == "start" and "Started" or "Stopped")
            end
            refresh()
        end, 60000)
        if not started then
            busy = false
            operationError = "Could not launch service operation"
            render()
        end
    end)
end

render()
refresh()
