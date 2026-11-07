// Update theme colors without refreshing the page
(() => {
  let timer;
  let pending;
  function updateTheme() {
    if (document.hidden || pending) return;
    const current = document.getElementById("theme");
    if (!current) return;
    const next = document.createElement("link");
    next.rel = "stylesheet";
    next.href = `style.css?theme=${Date.now()}`;
    pending = next;
    const timeout = setTimeout(() => discard(), 5000);
    function discard() {
      clearTimeout(timeout);
      next.remove();
      if (pending === next) pending = undefined;
    }
    next.onload = () => {
      clearTimeout(timeout);
      current.remove();
      next.id = "theme";
      pending = undefined;
    };
    next.onerror = discard;
    current.after(next);
  }
  function onVisibilityChange() {
    clearInterval(timer);
    if (document.hidden) return;
    updateTheme();
    timer = setInterval(updateTheme, 2000);
  }
  document.addEventListener("visibilitychange", onVisibilityChange);
  window.addEventListener("pagehide", () => {
    clearInterval(timer);
    if (pending) pending.remove();
    pending = undefined;
  });
  window.addEventListener("pageshow", onVisibilityChange);
})();
