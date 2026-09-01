-- Personal keybindings.
-- Loaded after Omarchy defaults (see ~/.config/hypr/hyprland.lua).

-- split-monitor-workspaces (Lua package, branch release/0.56.x)
-- Repo lives in ~/.config/hypr/plugins/split-monitor-workspaces (NOT in dotfiles).
-- Docs: ~/dotfiles/agents/.agents/skills/omarchy-custom/split-monitor-workspaces.md
package.path = package.path .. ";./?.lua;./?/init.lua"
local smw_ok, smw = pcall(require, "plugins.split-monitor-workspaces")

if smw_ok then
  smw.setup({
    workspace_count = 10,               -- workspaces per monitor
    keep_focused = false,               -- don't force focus after reload
    enable_notifications = true,        -- popup notifications on workspace switch
    enable_persistent_workspaces = true,-- always create all workspaces per monitor
    enable_wrapping = false,            -- no wrap-around when cycling
  })

  -- Remove Omarchy default workspace bindings (SUPER+1..10 via keycode, SUPER+TAB).
  for ws = 1, 10 do
    local key = "code:" .. tostring(ws + 9)
    hl.unbind("SUPER + " .. key)
    hl.unbind("SUPER + SHIFT + " .. key)
  end
  hl.unbind("SUPER + TAB")
  hl.unbind("SUPER + SHIFT + TAB")

  -- Per-monitor workspaces: SUPER+1..0 switches, SUPER+SHIFT+1..0 moves window.
  for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end
    hl.bind("SUPER + " .. n, smw.workspace(n),
      { description = "Switch to workspace " .. i .. " (this monitor)" })
    hl.bind("SUPER + SHIFT + " .. n, smw.move_to_workspace_silent(n),
      { description = "Move window to workspace " .. i .. " (this monitor)" })
  end

  -- Cycle workspaces on the current monitor.
  hl.bind("SUPER + TAB", smw.cycle_workspaces("next"),
    { description = "Next workspace (this monitor)" })
  hl.bind("SUPER + SHIFT + TAB", smw.cycle_workspaces("prev"),
    { description = "Previous workspace (this monitor)" })

  -- Focus next/previous monitor.
  -- NOTE: these override Omarchy defaults (SUPER+SHIFT+N was "Editor",
  -- SUPER+SHIFT+M was "Music") — unbound on purpose.
  hl.unbind("SUPER + SHIFT + N")
  hl.unbind("SUPER + SHIFT + M")
  hl.bind("SUPER + SHIFT + N", hl.dsp.focus({ monitor = "+1" }),
    { description = "Focus next monitor" })
  hl.bind("SUPER + SHIFT + M", hl.dsp.focus({ monitor = "-1" }),
    { description = "Focus previous monitor" })
else
  o.exec_on_start(
    "notify-send -u critical Hyprland 'split-monitor-workspaces Lua package missing: ~/.config/hypr/plugins/split-monitor-workspaces'")
end

-- Monitor layouts: SUPER+F7 = work (3 monitors + laptop), SUPER+F8 = home (laptop + Xiaomi).
o.bind("SUPER + F7", "Work monitor layout",
  os.getenv("HOME") .. "/.config/hypr/scripts/workspace-setup.sh work")
o.bind("SUPER + F8", "Home monitor layout",
  os.getenv("HOME") .. "/.config/hypr/scripts/workspace-setup.sh home")
