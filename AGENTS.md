# Repository Guidelines

## Project Structure & Module Organization
- Root: `flake.nix` (entrypoint) and `flake.lock`.
- `darwin/`: host-level config (`darwin.nix`, `brew.nix`, `system-defaults.nix`).
- `home/`: user-level modules (`home.nix`, `packages.nix`, `aliases.nix`).
- Docs/notes: `NIX-IMPROVEMENTS.md`, `WARP.md`, `apps_manual_install.txt`.

## Build, Test, and Development Commands
- `nix flake check .`: validate flake and module evaluation.
- `darwin-rebuild build --flake .#ZoBookPro`: build the system without applying.
- `sudo darwin-rebuild switch --flake .#ZoBookPro`: apply the system config.
- `home-manager switch --flake .`: apply Home Manager modules.
- `nix flake update`: update inputs; commit `flake.lock`.
Examples via Fish aliases (see `home/aliases.nix`): `drs`, `hmrs`, `nrs`, `nup`, `nck`.

## Coding Style & Naming Conventions
- Format Nix with `nixpkgs-fmt` before committing.
- Indentation: 2 spaces; one attribute per line; keep sets tidy.
- Filenames: kebab-case for modules (e.g., `system-defaults.nix`).
- Keep host-specific values in `darwin/*.nix`; shared/reusable settings in `home/*`.

## Testing Guidelines
- Prefer building before switching: `darwin-rebuild build --flake .#ZoBookPro`.
- If evaluation fails, re-run with `--show-trace` for details.
- After switching, sanity-check in a new shell (e.g., `fish --version`, `nix --version`, run `sysinfo`).

## Commit & Pull Request Guidelines
- Use Conventional Commits when possible: `feat:`, `fix:`, `refactor:`, `docs:`.
- Keep diffs focused; run `nixpkgs-fmt` and `nix flake check` before push.
- PRs should describe scope, affected paths (e.g., `darwin/brew.nix`), and note local validation commands/output. Link issues when relevant.

## Security & Configuration Tips
- Never commit secrets. Use 1Password CLI helpers defined in `home/home.nix` (`load_op_key`, `load_api_keys`).
- Current host is `ZoBookPro`. New hosts should be added under `darwinConfigurations` in `flake.nix` with host-specific modules in `darwin/`.

