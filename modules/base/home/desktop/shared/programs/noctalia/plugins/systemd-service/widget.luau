--!nonstrict
local service = noctalia.getConfig("service")
local user = noctalia.getConfig("user")
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
local currentColor = "outline"

local function render()
    local active = properties.ActiveState or "unknown"
    local transitioning = active == "activating" or active == "deactivating" or active == "reloading"
    local failed = not valid or active == "failed" or properties.LoadState == "not-found" or queryError ~= nil
    local color = currentColor
    if not busy and not transitioning then
        color = (failed or operationError) and "error"
            or active == "active" and "on_surface" or "outline"
        currentColor = color
    end
    barWidget.render(ui.glyph({ name = noctalia.getConfig("glyph"), color = color }))
    if not valid then
        barWidget.setTooltip({ { key = "Error", value = "Invalid systemd service name" } })
        return
    end
    local tooltip = {
        { key = "Service", value = service },
        { key = "Scope", value = user and "User" or "System" },
        { key = "State", value = active .. " / " .. (properties.SubState or "unknown") },
        { key = "Loaded", value = properties.LoadState or "unknown" },
        { key = "Enabled", value = properties.UnitFileState or "unknown" },
    }
    if properties.Description and properties.Description ~= "" then
        table.insert(tooltip, 2, { key = "Description", value = properties.Description })
    end
    tooltip[#tooltip + 1] = { key = "Action", value = busy and "Changing service state…" or "Click to start/stop" }
    if queryError then tooltip[#tooltip + 1] = { key = "Error", value = queryError } end
    if operationError then tooltip[#tooltip + 1] = { key = "Error", value = operationError } end
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
    if not busy then refresh() end
end

function onHover(entered)
    if entered and not busy then refresh() end
end

function onClick()
    if not valid or busy or querying then return end
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

noctalia.setUpdateInterval(noctalia.getConfig("interval") * 1000)
render()
refresh()
