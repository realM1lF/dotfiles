-- Household agent float. Hide via special:companion, do not kill.
-- Docs: ~/.agents/skills/omarchy-custom/rin-companion.md
-- Required from ~/.config/hypr/hyprland.lua (that file is local, not stowed).

o.window({ class = "^rin-companion$" }, {
  float = true,
  center = true,
  size = { 900, 620 },
  workspace = "special:companion silent",
})
