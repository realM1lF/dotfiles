-- Managed by workspace-setup.sh -- do not edit manually.
-- Regenerate: ~/.config/hypr/scripts/workspace-setup.sh [work|home|auto]
-- Current layout: home

local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

hl.monitor({ output = "eDP-1", mode = "1920x1200@60.00", position = "0x0", scale = 1 })
hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor 0000000000000", mode = "3440x1440@50.00", position = "1920x0", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x00030432", disabled = true })
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x0003E9A7", disabled = true })

-- Fallback for unknown monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
