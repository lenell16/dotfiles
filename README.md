# dotfiles

Declarative macOS system configuration for `ZoBookPro` (Apple Silicon).

## Stack

- **nix-darwin** + **home-manager** — primary config layer
- **Homebrew** — secondary layer for GUI apps and packages with Hydra cache issues

## Quick start

| Alias | Command |
|-------|---------|
| `drs` | `sudo darwin-rebuild switch --flake ~/Developer/personal/dotfiles` |
| `hmrs` | `home-manager switch --flake ~/Developer/personal/dotfiles#alonzothomas` |
| `nrs` | Full rebuild (both of the above) |
| `nup` | `nix flake update` |
| `nck` | `nix flake check` |
| `nopt` | Optimize the Nix store |
| `ngc` | Garbage collect + delete old generations |

Format Nix files with `nix fmt` (uses `nixfmt-rfc-style`).

## Repo structure

```
flake.nix            # root flake: inputs, darwinConfigurations, homeConfigurations
darwin/darwin.nix    # system-level config: hostname, DNS, shells, launchd agents
darwin/brew.nix      # Homebrew taps, brews, casks
darwin/system-defaults.nix  # macOS preference knobs
home/home.nix        # user environment: programs, shell, git, SSH, aerospace
home/packages.nix    # home.packages list
home/aliases.nix     # fish aliases, abbreviations, quick-edit shortcuts
scripts/             # one-off scripts (e.g. 1Password URL sync)
```

## Key principles

- **Homebrew is declarative.** `cleanup = "zap"` removes anything undeclared.
- **1Password as SSH agent and secrets vault.** SSH keys live in 1Password; API keys are fetched with a 24 h local file cache.
- **Dual GitHub identities.** Conditional includes switch identities by path; SSH routing uses host aliases.
