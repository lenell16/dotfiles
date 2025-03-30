# Nix Configuration Improvements

## To-Do
- [x] Update to nix-darwin's newer hostname options
  - ✅ Added modern `system.defaults.{HostName,LocalHostName,ComputerName}` settings
  - ✅ Kept legacy settings for backward compatibility
  - ✅ Added clear documentation explaining both approaches
  - ✅ Improved organization of network-related settings

- [x] Add direnv/nix-direnv for project environments
  - ✅ Added direnv with nix-direnv for efficient environment caching
  - ✅ Enabled fish shell integration
  - ✅ Configuration added for seamless development environment switching
  - ✅ Persist nix environments between shells for faster project switching

- [x] Create a consistent alias system
  - ✅ Created dedicated aliases.nix file for better organization
  - ✅ Grouped aliases by function (git, nix, system, navigation, etc.)
  - ✅ Added convenience aliases for common nix operations
  - ✅ Standardized naming conventions across all aliases
  - ✅ Added fish abbreviations for frequently used commands

- [x] Organize package categories
  - ✅ Grouped packages by function in both brew.nix and packages.nix
  - ✅ Added descriptive comments explaining each package's purpose
  - ✅ Organized Homebrew casks and Mac App Store apps by category
  - ✅ Kept useful commented packages with explanations for future reference
  - ✅ Improved readability with consistent spacing and formatting

- [x] Add system maintenance aliases
  - ✅ Created extensive system management alias categories
  - ✅ Added rebuild commands with descriptive names and comments
  - ✅ Included update helpers for flake dependencies
  - ✅ Added various garbage collection commands for different scenarios
  - ✅ Implemented a health check command and generation management
  - ✅ Added quick edit commands for all configuration files

- [x] Enable garbage collection
  - ✅ Added automatic garbage collection on a weekly schedule
  - ✅ Set 30-day retention policy for nix store
  - ✅ Configured auto-optimisation of the nix store
  - ✅ Added trusted users for additional operations
  - ✅ Added more efficient build settings

- [ ] ~~Add declarative VSCode configuration~~ (Decided against this)
  - Keeping VS Code configuration manual is preferred
  - Extensions can be managed through VS Code's sync features
  - Settings can be synced via GitHub account
  - More flexibility for frequent updates with VS Code Insiders

- [x] Improve fish configuration
  - ✅ Added useful fish functions (nixconf, sysinfo, etc.)
  - ✅ Improved fish colors and integration with starship
  - ✅ Added better organization and documentation
  - ✅ Improved shell startup with better comments
  - ✅ Set up proper Homebrew integration

## Completed

- [x] **Update to nix-darwin's newer hostname options** - Added modern hostname configuration while maintaining compatibility with older settings.
- [x] **Add direnv/nix-direnv for project environments** - Integrated direnv with fish for efficient project environment switching.
- [x] **Create a consistent alias system** - Created a dedicated aliases.nix file with organized categories for all shell aliases and abbreviations.
- [x] **Organize package categories** - Grouped packages by function with clear comments in both brew.nix and packages.nix.
- [x] **Add system maintenance aliases** - Added comprehensive set of aliases and abbreviations for system management, maintenance, and debugging.
- [x] **Enable garbage collection** - Configured automatic garbage collection with retention policies to maintain system health.
- [x] **Improve fish configuration** - Enhanced fish shell with useful functions, better colors, and improved organization.

### Node Migration Plan
When switching from Node 18 to Node 20, reinstall these global packages:
```
npm install -g @anthropic-ai/claude-code@0.2.56 @microsoft/teamsfx-cli@2.1.2 dotenv-cli@7.4.2 grpc-tools@1.12.4 node-gyp@10.1.0 protoc-gen-grpc@2.0.4 tailwindcss@4.0.9
```