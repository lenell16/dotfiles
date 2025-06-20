# AGENT.md - Nix Darwin Configuration

## Commands
- `darwin-rebuild switch --flake .` - Apply system configuration changes
- `nix flake update` - Update all flake inputs/dependencies
- `nix build .#darwinConfigurations.ZoBookPro.system` - Build system without applying
- `nixpkgs-fmt **/*.nix` - Format all Nix files
- `nix flake check` - Validate flake configuration
- `home-manager switch --flake .` - Apply home-manager config (if standalone)

## Architecture
- `flake.nix` - Entry point defining darwinConfiguration for "ZoBookPro" system
- `darwin/` - System-level macOS configuration (brew, system defaults, packages)
- `home/` - User environment via home-manager (packages, aliases, dotfiles)
- Uses nix-darwin + home-manager integration for complete system management

## Code Style
- 2-space indentation for Nix expressions
- Group imports at top of files
- Comments for optional/complex configurations
- Separate concerns: packages.nix, aliases.nix, brew.nix, system-defaults.nix
- Declarative attribute sets with consistent formatting
- Allow unfree packages globally in nixpkgs.config
