# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a personal Nix configuration for macOS using nix-darwin and home-manager. The configuration manages both system-level settings and user environment in a declarative manner.

## Architecture

- **`flake.nix`** - Entry point defining the darwinConfiguration for "ZoBookPro" system
- **`darwin/`** - System-level macOS configuration
  - `darwin.nix` - Main system configuration, networking, shells, fonts
  - `brew.nix` - Homebrew packages, casks, and Mac App Store apps  
  - `system-defaults.nix` - macOS system defaults and preferences
- **`home/`** - User environment via home-manager
  - `home.nix` - Main user configuration, programs, and dotfiles
  - `packages.nix` - Nix packages for user environment
  - `aliases.nix` - Fish shell aliases and abbreviations organized by category

The system uses nix-darwin + home-manager integration for complete system management, with the configuration targeting Apple Silicon (aarch64-darwin).

## Essential Commands

### System Rebuild & Updates
```fish
# Apply system configuration changes
darwin-rebuild switch --flake .

# Apply only user environment changes  
home-manager switch --flake .

# Full system rebuild (both system + user)
nrs  # alias for both commands above

# Update all flake inputs/dependencies
nix flake update

# Update dependencies and rebuild in one command
nsu  # abbreviation
```

### Development Workflow
```fish
# Build system configuration without applying
nix build .#darwinConfigurations.ZoBookPro.system

# Format all Nix files
nixpkgs-fmt **/*.nix

# Validate flake configuration
nix flake check

# Quick health check
nix-health  # alias that runs flake check
```

### Configuration Management
```fish
# Navigate to config directory
ncd  # alias

# Edit specific config files
nhome      # Edit home/home.nix
ndarwin    # Edit darwin/darwin.nix  
npackages  # Edit home/packages.nix
nbrew      # Edit darwin/brew.nix
naliases   # Edit home/aliases.nix
```

### Maintenance & Cleanup
```fish
# Garbage collection - delete old generations
ngc  # alias for nix-collect-garbage -d

# Optimize store by hardlinking identical files
nopt  # alias for nix-store --optimize

# View system generations
ngl   # List system generations
ngld  # List darwin generations  
nhlg  # List home-manager generations
```

## Key Configuration Details

### User Environment
- **Shell**: Fish with extensive aliases and functions organized in `aliases.nix`
- **Editor**: Neovim set as default editor with vi/vim aliases
- **Terminal**: Ghostty (via Homebrew due to build issues in Nix)
- **Window Manager**: AeroSpace with custom keybindings
- **Package Management**: Mix of Nix packages and Homebrew for GUI applications

### System Integration
- Allows unfree packages globally (`allowUnfree = true`)
- Fish shell integration with Starship prompt, direnv, fzf, and zoxide
- Homebrew managed through Nix for GUI apps and system libraries
- 1Password CLI integration with secure key caching functions
- Git configuration with conditional includes for personal vs work profiles

### Development Tools
Key development packages include:
- Language runtimes: Node.js 20, Deno, Bun, Python (uv)
- Cloud tools: Azure CLI, Supabase CLI, Infisical
- Containers: Podman, Docker CLI client  
- Databases: PostgreSQL 14, pgvector, DataGrip IDE
- Version control: Git with GitUI, LazyGit, GitHub CLI

## Code Style & Conventions

- **Indentation**: 2 spaces for Nix expressions
- **Organization**: Group imports at top, separate concerns into focused files
- **Comments**: Document optional/complex configurations and package purposes
- **Formatting**: Consistent attribute set formatting with `nixpkgs-fmt`
- **Structure**: Declarative configuration style with modular organization

## Git Configuration

The repository uses conditional Git includes:
- Default work profile: "Alonzo Thomas" <alonzo.thomas@tribble.ai>
- Personal projects: "lenell16" <lenell16@gmail.com> (for ~/Developer/personal/)
- Work projects: "Alonzo Thomas" <alonzo.thomas@tribble.ai> (for ~/Developer/tribble/)

## Dependencies & Inputs

Key flake inputs:
- `nixpkgs` - Main package repository (nixpkgs-unstable)
- `nix-darwin` - macOS system management
- `home-manager` - User environment management  
- `neovim-overlay` - Neovim nightly builds
- `gitalias` - Git aliases collection
- `flake-utils` - Flake utilities

## Fish Shell Features

Custom functions available:
- `sysinfo` - Display system information
- `mcd <dir>` - Create directory and cd into it  
- `load_op_key` - Load API keys from 1Password with caching
- `load_api_keys` - Load all configured API keys
- Extensive aliases organized by category (git, nix, navigation, etc.)
