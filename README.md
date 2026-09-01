# Dotfiles

This repository contains my personal configuration files (dotfiles) managed with [GNU Stow](https://www.gnu.org/software/stow/). Stow is a symlink farm manager that makes it easy to organize and deploy configuration files across different systems.

## Prerequisites

Make sure you have GNU Stow installed on your system:

```bash
# Arch Linux
sudo pacman -S stow

# Debian/Ubuntu
sudo apt install stow

# macOS
brew install stow
```

## Installation

Clone this repository to your home directory:

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
```

## Available Packages

This repository contains the following stow packages:

- **hyprland** - Hyprland window manager configuration (Lua format, Omarchy 4)
- **omarchy** - Omarchy shell plugins (`~/.config/omarchy/plugins/`)
- **agents** - Agent skills for `~/.agents/skills/` (e.g. `omarchy-custom`)
- **ssh** - SSH configuration
- **opendeck** - OpenDeck configuration
- **kanshi** - Kanshi configuration (currently not in use)
- **scripts** - User scripts in `~/.local/bin/` (e.g. fingerprint toggle)

### `_old/` — Omarchy 3 leftovers (do NOT stow)

Everything in `_old/` is kept for reference only and is not a stow package:

- `_old/hyprland/` — old `.conf` Hyprland config (Omarchy 3). Omarchy 4 uses Lua (`*.lua`); the `*.conf` files are no longer read.
- `_old/waybar/` — Waybar config. Omarchy 4 replaced Waybar with the Quickshell-based Omarchy shell.
- `_old/omarchy/` — custom themes in the old Omarchy 3 format (waybar.css, mako.ini, ...). Omarchy 4 uses a new theme format.

### System Files (require root — not stow-managed)

Files in `system/` must be installed manually once:

```bash
bash ~/dotfiles/system/install.sh
```

This installs:
- `/usr/local/bin/omarchy-fingerprint-pam-toggle` — PAM helper for fingerprint toggle
- `/etc/sudoers.d/fingerprint-toggle` — NOPASSWD rule for the helper

## Stow Commands

### Installing Individual Packages

To symlink a specific package, run the following command from the `~/dotfiles` directory:

```bash
# Hyprland configuration
stow hyprland

# Agent skills
stow agents

# SSH configuration
stow ssh

# OpenDeck configuration
stow opendeck

# Omarchy shell plugins
stow omarchy

# Kanshi configuration
stow kanshi
```

### Installing All Packages

To install all packages at once (list them explicitly — do NOT use `stow */`, because `_old/` must never be stowed):

```bash
stow hyprland omarchy agents ssh opendeck kanshi scripts
```

### Uninstalling Packages

To remove symlinks for a specific package:

```bash
# Example: uninstall hyprland
stow -D hyprland

# Example: uninstall agents
stow -D agents

# Example: uninstall ssh
stow -D ssh

# Example: uninstall opendeck
stow -D opendeck

# Example: uninstall kanshi
stow -D kanshi
```

To uninstall all packages:

```bash
stow -D hyprland omarchy agents ssh opendeck kanshi scripts
```

### Restowing Packages

If you've made changes and want to refresh the symlinks:

```bash
# Example: restow hyprland
stow -R hyprland

# Restow all packages
stow -R hyprland omarchy agents ssh opendeck kanshi scripts
```

### Dry Run

To see what stow would do without actually making changes:

```bash
# Example: dry run for hyprland
stow -n hyprland

# Dry run for all packages
stow -n hyprland omarchy agents ssh opendeck kanshi scripts
```

## Directory Structure

```
dotfiles/
├── hyprland/
│   └── .config/
│       └── hypr/           # Lua config: bindings.lua, monitors.lua, autostart.lua + scripts/
├── agents/
│   └── .agents/
│       └── skills/         # stow → ~/.agents/skills/
├── ssh/
│   └── .ssh/
│       └── config
├── opendeck/
│   └── .config/
│       └── opendeck/
├── omarchy/
│   └── .config/
│       └── omarchy/
│           └── plugins/    # user shell plugins (e.g. rin.workspaces)
├── kanshi/
│   └── .config/
│       └── kanshi/
├── scripts/
│   └── .local/
│       └── bin/            # stow → ~/.local/bin/
├── system/                 # NOT stow-managed — install with system/install.sh
│   ├── install.sh
│   ├── usr/local/bin/
│   └── etc/sudoers.d/
└── _old/                   # Omarchy 3 leftovers, reference only — NEVER stow
    ├── hyprland/           # old .conf format
    ├── waybar/             # Waybar (removed in Omarchy 4)
    └── omarchy/            # themes in old format
```

## Notes

- Stow creates symlinks in the parent directory by default (i.e., `~/` when run from `~/dotfiles`)
- If a file already exists at the target location, stow will report a conflict
- Always backup your existing configuration files before stowing new ones
- Use `stow -n` (dry run) to preview changes before applying them

## Troubleshooting

If you encounter conflicts during stowing:

1. Backup existing configuration files
2. Remove or rename conflicting files
3. Run the stow command again

Example:

```bash
# Backup existing config
mv ~/.config/hypr ~/.config/hypr.backup

# Then stow
stow hyprland
```

## License

These are personal configuration files. Feel free to use and modify them as needed.
