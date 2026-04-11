# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Declarative macOS system configuration for `ZoBookPro` (Apple Silicon). Uses **nix-darwin** + **home-manager** as the primary config layer, with **Homebrew** as a secondary layer for GUI apps and packages with Hydra cache issues.

## Rebuild Commands

| Command | What it does |
|---------|-------------|
| `drs` | `sudo darwin-rebuild switch --flake ~/Developer/personal/dotfiles` — rebuilds system (nix-darwin) |
| `hmrs` | `home-manager switch --flake ~/Developer/personal/dotfiles#alonzothomas` — rebuilds user env only |
| `nrs` | Both of the above combined (full rebuild) |
| `nup` | `nix flake update` — updates all flake inputs |
| `nck` | `nix flake check` — validates the flake |
| `nopt` | Optimizes the Nix store |
| `ngc` | Garbage collect + delete old generations |

Format Nix files with:
```
nix fmt
```
(uses `nixfmt-rfc-style` as configured in `flake.nix`)

Dev shell with Nix tooling (`nixfmt-rfc-style`, `nix-tree`, `nix-info`):
```
nix develop
```

## File Map

- `flake.nix` — root: inputs, `darwinConfigurations."ZoBookPro"`, `homeConfigurations."alonzothomas"`, shared `mkPkgs` helper
- `darwin/darwin.nix` — system-level config: hostname, DNS, shells, launchd agents, fonts, sudo Touch ID
- `darwin/brew.nix` — all Homebrew taps/brews/casks (declarative; `cleanup = "zap"` removes anything undeclared)
- `darwin/system-defaults.nix` — macOS preference knobs (Dock, Finder, trackpad, screenshots, etc.)
- `home/home.nix` — user environment: programs, shell, git, SSH, aerospace WM, activation hooks
- `home/packages.nix` — `home.packages` list (Nix-managed CLI/dev tools)
- `home/aliases.nix` — fish shell aliases, abbreviations, and quick-edit shortcuts (`nhome`, `ndarwin`, etc.)

## Key Architecture Decisions

**Homebrew is declarative.** `cleanup = "zap"` means anything not listed in `brew.nix` is removed on rebuild. Never install Homebrew packages imperatively — declare them in `brew.nix`.

**Pinned nixpkgs for binary cache.** `nixpkgs-pinned` (commit `8fb5010d...`) is used for `azure-functions-core-tools` and `transmission_4` to get binary cache hits. When adding packages that fail to build from source, consider pinning.

**`nix.enable = false`.** Nix daemon is managed by the Determinate Systems installer, not nix-darwin. Do not change this.

**1Password as SSH agent and secrets vault.** SSH keys live in 1Password; the Unix socket is symlinked to `~/.ssh/1password/agent.sock` (avoids path-with-spaces issue). API keys are fetched from 1Password vault with a 24h local file cache via the `load_op_key` fish function.

**Dual GitHub identities.** Git uses conditional includes to switch identities:
- `~/Developer/personal/**` → `lenell16` / Gmail
- `~/Developer/tribble/**` → work identity
SSH routing uses host aliases `github.com-personal` and `github.com-work`.

**Ghostty is split.** Installed via Homebrew cask (works); `programs.ghostty` in home-manager is disabled due to build issues. Configure Ghostty settings through the cask, not home-manager.

**Aerospace uses Colemak navigation.** In service mode, window focus/move uses `n/e/o/i` (left/down/up/right), not `h/j/k/l`. JankyBorders (`FelixKratz/formulae/borders`) provides the orange active-window highlight.

## Adding Packages

- **Nix CLI tools** → `home/packages.nix`
- **Nix programs with config** → `home/home.nix` under `programs.*`
- **Homebrew GUI apps (casks)** → `darwin/brew.nix` under `casks`
- **Homebrew CLI tools** → `darwin/brew.nix` under `brews`
- **System-level packages** → `darwin/darwin.nix` under `environment.systemPackages`
