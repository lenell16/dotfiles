# CLAUDE.md - Project Information

## Project Type
Personal Nix configuration for macOS (Darwin) using nix-darwin and home-manager.

## Commands
- `nix flake update` - Update dependencies
- `darwin-rebuild switch --flake .` - Apply system changes
- `nixpkgs-fmt **/*.nix` - Format Nix files
- `nix build .#darwinConfigurations.macbook-pro.system` - Build system configuration

## Code Style
- 2-space indentation
- Comments for optional configurations
- Modules organized by function (darwin/, home/)
- Imports grouped at top of files
- Declarative configuration style

## Conventions
- Package definitions in separate files (home/packages.nix, darwin/brew.nix)
- System defaults in darwin/system-defaults.nix
- User environment in home/home.nix
- Homebrew packages managed through Nix

## Organization
- darwin/ - System-level configuration
- home/ - User environment setup 
- flake.nix - Entry point defining system configurations