# Nix Upgrade Checklist

_A running list of modernization ideas to review and optionally implement. Update the checkboxes in-place as work progresses._

Legend:
- `Reviewed` — You have examined the idea and decided whether it applies.
- `Implemented` — The change is merged/applied (or intentionally rejected; note that in "Notes").

## Darwin Host Configuration

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| D-01 | Re-enable nix-darwin’s built-in Nix management (`nix.enable = true;`) and move daemon tuning into `nix.settings`, replacing the legacy manual `/etc/nix/nix.conf` workflow now that `services.nix-daemon.enable` has been removed upstream.<br/>[Details](#d-01-let-nix-darwin-manage-the-nix-daemon) | [x] | [ ] | Blocked while Determinate Nix manages the daemon
| D-02 | Remove the giant manually-crafted PATH export in `environment.variables` and instead rely on declarative path assembly (`environment.profiles`, `environment.systemPackages`, `programs.fish`, shell init modules) so new packages land automatically.<br/>[Details](#d-02-declarative-path-management-instead-of-hard-coded-strings) | [x] | [x] | PATH now composed via `environment.profiles` + `home.sessionPath`
| D-03 | Adopt the newer PAM helpers in nix-darwin (e.g., `security.pam.enableSudoTouchIdAuth = true;`, login service tweaks) to keep Touch ID sudo and similar niceties declarative and upgrade-safe.<br/>[Details](#d-03-enable-modern-macos-security-helpers) | [x] | [x] | Touch ID handled via `security.pam.services.sudo_local`
| D-04 | Drop the `activationScripts.postActivation` `chsh` workaround and rely on nix-darwin’s shell registration (`users.users.<name>.shell` + `/etc/shells` management).<br/>[Details](#d-04-remove-postactivation-chsh-hook) | [x] | [x] | Declarative shell via `users.users` & `environment.shells`; postActivation hook removed |
| D-05 | Re-evaluate Dock & Finder defaults against Ventura/Sonoma changes—hot-corner keys now cover Stage Manager/Quick Note, and `static-only` changed semantics.<br/>[Details](#d-05-refresh-dock-and-finder-defaults-for-modern-macos) | [ ] | [ ] | |
| D-06 | Layer in fresh `NSGlobalDomain` toggles (press-and-hold, menu bar visibility, expanded save panels, auto-capitalization) introduced since Monterey.<br/>[Details](#d-06-add-newer-nsglobaldomain-toggles) | [ ] | [ ] | |
| D-07 | Expand `screencapture`, `dock`, and menu extras defaults with Sonoma-era options (autohide delay, clock customizations, stage manager toggles) for finer UX control.<br/>[Details](#d-07-extend-defaults-with-sonoma-era-options) | [ ] | [ ] | |
| D-08 | Update firewall config to include logging, stealth mode, and signed-app behaviour that newer nix-darwin exposes.<br/>[Details](#d-08-expand-firewall-configuration) | [ ] | [ ] | |
| D-09 | Switch font provisioning to the new nerdfonts overrides / aggregated packages to avoid attr renames and slim the closure.<br/>[Details](#d-09-modernize-font-packages) | [ ] | [ ] | |
| D-10 | Break out host-specific modules under `darwin/modules/` so multiple Macs can share logic without copy/paste.<br/>[Details](#d-10-split-host-specific-modules) | [ ] | [ ] | |

## Home Manager Configuration

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| HM-01 | Rewrite Fish functions using the structured HM API (`programs.fish.functions.NAME = { description = ...; body = '' ... ''; };`) to gain metadata, autoloading, and cleaner diffs.<br/>[Details](#hm-01-structured-fish-functions) | [ ] | [ ] | |
| HM-02 | Move brew shellenv and other login-only commands into `programs.fish.loginShellInit` so subshells don’t re-run heavy init logic, matching Ventura’s login shell semantics.<br/>[Details](#hm-02-use-loginshellinit-for-login-only-commands) | [x] | [x] | Homebrew shellenv now runs via `loginShellInit`
| HM-03 | Upgrade Starship config with per-module tweaks (disabling unused modules, `add_newline = false`, command duration gating) introduced since HM 23.x.<br/>[Details](#hm-03-refresh-starship-configuration) | [ ] | [ ] | |
| HM-04 | Enable supporting tooling such as `programs.nix-index`, `programs.command-not-found`, or `programs.nix-index-database` for instant package lookup from the shell.<br/>[Details](#hm-04-enable-package-discovery-toolkits) | [ ] | [ ] | |
| HM-05 | Turn on `services.lorri` or the newer `services.direnv` module so dev shells rebuild automatically without manual `direnv allow` juggling.<br/>[Details](#hm-05-adopt-dev-shell-services) | [ ] | [ ] | |
| HM-06 | Manage Ghostty config declaratively via HM (either enabling `programs.ghostty` if the package builds, or syncing config through `xdg.configFile`).<br/>[Details](#hm-06-manage-ghostty-configuration-declaratively) | [ ] | [ ] | |
| HM-07 | Audit language/runtime packages (`uv`, `turbo`, etc.) against current nixpkgs naming (e.g., `astral-uv`, `nodePackages_latest.turbo`) to avoid evaluation failures.<br/>[Details](#hm-07-audit-runtime-packages-for-renames) | [ ] | [ ] | |
| HM-08 | Use HM’s conditional include support (`programs.git.includes = [{ condition = "gitdir:..."; path = ...; }];`) to separate work/personal Git identities cleanly.<br/>[Details](#hm-08-modernize-git-conditional-includes) | [ ] | [ ] | |
| HM-09 | Replace complex inline `$PATH` manipulation with `home.sessionPath`, `home.sessionVariables`, and `lib.mkForce` to compose env vars predictably.<br/>[Details](#hm-09-modernize-session-variable-management) | [ ] | [ ] | |
| HM-10 | Use `home.activation` hooks or `xdg.portal` modules for macOS integration tasks (e.g., clearing caches, portal support for sandboxed apps).<br/>[Details](#hm-10-use-home-activation-and-portal-modules) | [ ] | [ ] | |

## Home Packages (`home/packages.nix`)

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| PKG-01 | Decide on a single Node.js distribution (nixpkgs vs Homebrew) and align PNPM/Turbo packages so PATH collisions disappear and updates come from one source.<br/>[Details](#pkg-01-consolidate-nodejs-tooling) | [x] | [x] | Sourced Node, pnpm, turbo exclusively from nixpkgs; no Homebrew overlap. |
| PKG-02 | Check for nixpkgs renames like `uv` → `astral-uv` and `turbo` living under `nodePackages_latest`; update your list to prevent evaluation failures during upgrades.<br/>[Details](#pkg-02-verify-package-renames) | [x] | [x] | Verified current nixpkgs attributes; `uv` and `turbo` remain valid. |
| PKG-03 | Shift heavyweight GUI apps (Raycast, DataGrip, IINA) to Homebrew or macOS-specific package sets so closures stay lean and updates piggyback on the cask ecosystem.<br/>[Details](#pkg-03-relocate-gui-apps) | [x] | [x] | Reviewed candidates; opting to keep under nixpkgs for now, no action needed. |
| PKG-04 | Sprinkle in newer tooling (`nixfmt-rfc-style`, `age`, `sops-nix`) to match current best practices around formatting and secrets management.<br/>[Details](#pkg-04-add-modern-developer-tooling) | [x] | [x] | Added `nixfmt-rfc-style`; other tooling deferred pending future need. |

## Flake Structure

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| FLK-01 | Publish a `formatter.${system}` (e.g., `nixfmt-rfc-style`) and `devShells.${system}.default` so `nix fmt` and `nix develop` work out-of-the-box on any checkout.<br/>[Details](#flk-01-provide-formatter-and-devshell-outputs) | [x] | [x] | Added formatter with nixfmt-rfc-style and default devShell with dev tools |
| FLK-02 | Use the flake-level `nixConfig` attr to declare substituters, trusted keys, and experimental features instead of relying on manual `/etc/nix/nix.conf` edits.<br/>[Details](#flk-02-declare-nix-config-in-the-flake) | [ ] | [ ] | |
| FLK-03 | Switch from a hand-rolled `system` let-binding to `flake-utils.lib.eachDefaultSystem` (or the new `perSystem`) so adding Linux builds/devShells is trivial.<br/>[Details](#flk-03-use-flake-utils-to-scale-systems) | [ ] | [ ] | |
| FLK-04 | Centralize `nixpkgs.config` and overlays so darwin/home-manager share one definition, reducing divergence between host/user builds.<br/>[Details](#flk-04-deduplicate-nixpkgs-configuration) | [ ] | [ ] | |
| FLK-05 | Create an `mkDarwinHost` helper (or `lib.genAttrs`) to define hosts declaratively, keeping multi-machine config DRY.<br/>[Details](#flk-05-introduce-host-construction-helpers) | [ ] | [ ] | |

## Homebrew Module

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| HB-01 | Confirm the current meaning of `homebrew.onActivation.cleanup` (`"none"`, `"rm"`, `"zap"`, `"uninstall"`) and ensure `autoUpdate` aligns with how often you rebuild to avoid surprise upgrades.<br/>[Details](#hb-01-refresh-homebrew-activation-options) | [x] | [x] | Using `cleanup = "zap"`, `autoUpdate = false`, `upgrade = true`; cadence documented. |
| HB-02 | Flip on `homebrew.brewFile.enable = true;` so nix-darwin writes a Brewfile—handy for manual recovery or sharing with non-nix users.<br/>[Details](#hb-02-enable-brewfile-generation) | [x] | [x] | Reviewed; decided to keep Brewfile generation disabled for now. |
| HB-03 | Revisit custom taps to confirm they’re still maintained (e.g., `danvergara/tools`) or retire them to trim `brew update` noise.<br/>[Details](#hb-03-audit-homebrew-taps) | [x] | [x] | All current taps audited; no changes needed. |

## Shell Aliases & Functions

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| SH-01 | When overriding built-in aliases (e.g., `ls`), wrap them with `lib.mkForce` so HM wins against Fish defaults without spurious warnings.<br/>[Details](#sh-01-force-override-conflicting-aliases) | [x] | [x] | No warnings observed in current setup |
| SH-02 | Embrace Fish 4’s richer abbreviations via `programs.fish.shellAbbrsExtended`—they expand contextually and are easier to edit on the command line than plain aliases.<br/>[Details](#sh-02-use-modern-fish-abbreviations) | [x] | [x] | `shellAbbrsExtended` does not exist; current `shellAbbrs` is already modern and correct |
| SH-03 | Promote complex helpers like `nix-health` into HM functions so dependencies are tracked and the closure includes required binaries.<br/>[Details](#sh-03-convert-complex-helpers-into-functions) | [x] | [x] | Converted `nix-health` to HM function; benefits are minimal for simple helpers |

## Additional Integrations & Quality-of-Life

| ID | Description | Reviewed | Implemented | Notes |
|----|-------------|----------|-------------|-------|
| INT-01 | Wire 1Password CLI usage into HM (`programs.op` or custom activation scripts) so secrets load declaratively and you can toggle caching policies per environment.<br/>[Details](#int-01-integrate-secrets-handling) | [x] | [x] | Enabled nix-darwin `programs._1password*`, HM fish helpers, and activation hook |
| INT-02 | Shift Aerospace settings into the latest HM module (`programs.aerospace.userSettings`, `settingsFile`) for version-aware schema validation.<br/>[Details](#int-02-manage-aerospace-via-home-manager) | [x] | [x] | Home Manager now owns config + launchd agent |
| INT-04 | Keep terminal configs (WezTerm, Alacritty, Ghostty) in HM-managed files so theme/font tweaks propagate instantly across machines.<br/>[Details](#int-04-manage-terminal-configs) | [x] | [x] | |
| INT-05 | Use nix-darwin `launchd.daemons`/`launchd.agents` for background tasks (e.g., auto-starting Podman machine) instead of ad-hoc shell scripts.<br/>[Details](#int-05-use-launchd-modules-for-background-jobs) | [x] | [x] | Implemented podman machine autostart via launchd.user.agents + container restart policies |
| INT-06 | Adopt `home.persistence` / impermanence modules to declaratively persist or wipe directories, useful for scratch vs. long-lived data separation.<br/>[Details](#int-06-adopt-impermanence-patterns) | [ ] | [ ] | |

## Detailed Notes

### D-01 — Let nix-darwin manage the Nix daemon

- **What changed:** the upstream module removed `services.nix-daemon.enable`; when `nix.enable = true;`, nix-darwin always provisions the daemon and expects configuration via `nix.settings` and related `nix.*` options (see the [module source](https://raw.githubusercontent.com/nix-darwin/nix-darwin/master/modules/services/nix-daemon.nix)).
- **Why it matters:** keeping daemon flags, substituters, and experimental features in the declarative config prevents drift in `/etc/nix/nix.conf`, especially after system updates or reinstalling Nix.
- **Impact:** enables auditable upgrades, easier multi-user installs, and centralized toggles for flakes/`nix-command` without manual post-install steps.

### D-02 — Declarative PATH management instead of hard-coded strings

- **What changed:** modern nix-darwin exposes `environment.profiles`, `environment.pathsToLink`, and shell modules that assemble `$PATH` automatically from declared packages.
- **Why it matters:** a hand-built PATH string goes stale when package locations change; declarative paths follow package upgrades automatically.
- **Impact:** fewer rebuild surprises and consistent PATH between interactive shells and services.

### D-03 — Enable modern macOS security helpers

- **What changed:** `security.pam.enableSudoTouchIdAuth`, `security.pam.services.login.touchIdAuth`, and related options landed after Monterey.
- **Why it matters:** Touch ID sudo and similar features survive OS updates when declared; manual PAM edits are brittle.
- **Impact:** better UX with biometric sudo while remaining reproducible.

### D-04 — Remove postActivation `chsh` hook

- **What changed:** nix-darwin automatically adds user shells to `/etc/shells` and sets the login shell when `users.users.<name>.shell` is defined.
- **Why it matters:** shelling out to `sudo chsh` during activation is redundant and can fail under stricter sudo policies.
- **Impact:** cleaner activations and fewer prompts during rebuilds.

### D-05 — Refresh Dock and Finder defaults for modern macOS

- **What changed:** hot corner keys now have values for Stage Manager and Quick Note; `static-only` semantics shifted in Ventura.
- **Why it matters:** old defaults might now map to "disabled" or conflict with new features.
- **Impact:** ensures Dock behaviour matches expectations post-upgrade.

### D-06 — Add newer `NSGlobalDomain` toggles

- **What changed:** recent macOS releases added keys like `ApplePressAndHoldEnabled`, `_HIHideMenuBar`, and enhanced auto-capitalization controls.
- **Why it matters:** these bring Mac keyboard ergonomics closer to developer preferences without manual `defaults write` commands.
- **Impact:** consistent behaviour across reinstalls, fewer manual tweaks.

### D-07 — Extend defaults with Sonoma-era options

- **What changed:** keys for `autohide-delay`, menu extra clock styles, Stage Manager toggles, screenshot defaults, etc., are now supported.
- **Why it matters:** default behaviour may feel sluggish or cluttered; new toggles give fine-grained control.
- **Impact:** higher fidelity to your desired UI tweaks without ad-hoc scripts.

### D-08 — Expand firewall configuration

- **What changed:** nix-darwin’s firewall module now exposes `logging`, `stealthMode`, and more granular signed-app allowances.
- **Why it matters:** shipping logs and stealth mode declaratively strengthens baseline security.
- **Impact:** easier compliance with security policies and less reliance on GUI toggles.

### D-09 — Modernize font packages

- **What changed:** Nerd Font derivations moved toward override-based packaging (`nerdfonts.override { fonts = [...] ; }`).
- **Why it matters:** older attr names may disappear; overrides download only desired fonts.
- **Impact:** smaller closure sizes and smoother channel updates.

### D-10 — Split host-specific modules

- **What changed:** nix-darwin best practice is to keep shared logic in reusable modules and have host entrypoints import them.
- **Why it matters:** if you add a second Mac, copy-paste becomes unmanageable.
- **Impact:** easier multi-host scaling and clearer separation of concerns.

### HM-01 — Structured Fish functions

- **What changed:** Home Manager added a first-class `programs.fish.functions.<name>` attrset with `description`, `body`, and `wraps` fields.
- **Why it matters:** structured definitions generate completions, improve diff readability, and allow per-function metadata.
- **Impact:** cleaner fish config and future compatibility.

### HM-02 — Use `loginShellInit` for login-only commands

- **What changed:** Ventura treats GUI-launched terminals differently; Home Manager exposes `loginShellInit` vs `interactiveShellInit` to control scope.
- **Why it matters:** heavy commands like `brew shellenv` shouldn’t run for every subshell.
- **Impact:** faster shell startup and fewer duplicate PATH exports.

### HM-03 — Refresh Starship configuration

- **What changed:** Starship gained module-level settings, `add_newline`, and improved toggles; HM surfaces all options.
- **Why it matters:** you can disable unused modules (e.g., gcloud) and control prompt spacing declaratively.
- **Impact:** snappier prompt and less clutter.

### HM-04 — Enable package discovery toolkits

- **What changed:** modules like `programs.nix-index`, `programs.command-not-found`, and `programs.nix-index-database` matured.
- **Why it matters:** they let you type `command-not-found` suggestions without waiting for `nix-search` or hitting the web.
- **Impact:** smoother workflows when hunting for packages.

### HM-05 — Adopt dev-shell services

- **What changed:** Home Manager can manage `lorri` and `direnv` services that watch project directories and rebuild envs.
- **Why it matters:** eliminates manual `lorri daemon` or repeated `direnv allow` actions.
- **Impact:** dev shells stay up-to-date automatically.

### HM-06 — Manage Ghostty configuration declaratively

- **What changed:** even if the binary comes from Homebrew, HM can own config files via `programs.ghostty` or `xdg.configFile`.
- **Why it matters:** ensures themes/fonts stay consistent across machines and rebuilds.
- **Impact:** one source of truth for terminal settings.

### HM-07 — Audit runtime packages for renames

- **What changed:** nixpkgs occasionally renames packages (e.g., `uv` to `astral-uv`), moves JS tools under `nodePackages_latest`, etc.
- **Why it matters:** outdated names cause evaluation failures during `darwin-rebuild`.
- **Impact:** smoother upgrades and less firefighting when channels advance.

### HM-08 — Modernize Git conditional includes

- **What changed:** HM supports condition-based includes (`programs.git.includes = [{ condition = "gitdir:..."; path = ...; }];`).
- **Why it matters:** lets you switch identities or configs per directory without manual `includeIf` boilerplate.
- **Impact:** tidy `.gitconfig` and less chance of leaking credentials.

### HM-09 — Modernize session variable management

- **What changed:** `home.sessionPath`, `home.sessionVariables`, and `lib.mkForce` make env composition easier.
- **Why it matters:** manual string interpolation breaks when nested `${...}` is involved.
- **Impact:** deterministic environment no matter how many shells you open.

### HM-10 — Use Home activation and portal modules

- **What changed:** `home.activation` offers declarative hooks; `xdg.portal` now works on macOS for compatible apps.
- **Why it matters:** tasks like clearing caches or setting up integration points belong in activation scripts, not manual shell commands.
- **Impact:** easier automation of once-off setup tasks.

### PKG-01 — Consolidate Node.js tooling

- **What changed:** you currently install Node via nixpkgs and rely on PNPM/Turbo packages; Homebrew also ships Node in taps.
- **Why it matters:** duplicate installs drift in version and PATH order clashes create confusion.
- **Impact:** choose one channel for Node tooling to simplify updates.

### PKG-02 — Verify package renames

- **What changed:** packages like `uv`, `turbo`, and others have been renamed or reorganized.
- **Why it matters:** failing builds due to missing attrs are common after nixpkgs updates.
- **Impact:** proactively updating names keeps `darwin-rebuild` smooth.

### PKG-03 — Relocate GUI apps

- **What changed:** big GUI apps are better managed via Homebrew casks or macOS application outputs.
- **Why it matters:** bundling them in `home.packages` balloons closures and duplicates downloads when Homebrew already handles them.
- **Impact:** leaner closures, quicker rebuilds, and consistent app update flow.

### PKG-04 — Add modern developer tooling

- **What changed:** new tools like `nixfmt-rfc-style`, `age`, `sops-nix`, etc., are now standard in many setups.
- **Why it matters:** they support new formatting guidelines and secrets workflows.
- **Impact:** keeps your toolchain aligned with current best practices.

### FLK-01 — Provide formatter and devShell outputs

- **What changed:** conventionally, flakes expose `formatter` and `devShells` to support `nix fmt` / `nix develop` defaults.
- **Why it matters:** contributors (or future you) can run formatting and open a dev shell without hunting for commands.
- **Impact:** better ergonomics and adoption of flake-native tooling.

### FLK-02 — Declare nix config in the flake

- **What changed:** `nixConfig` can live at the root of the flake, capturing substituters, trusted keys, and experimental features.
- **Why it matters:** ensures anyone using the flake inherits those settings without editing `/etc/nix/nix.conf`.
- **Impact:** easier onboarding on new machines and CI.

### FLK-03 — Use flake-utils to scale systems

- **What changed:** `flake-utils.lib.eachDefaultSystem` or the `perSystem` pattern remove the need to hardcode `system` each time.
- **Why it matters:** simplifies adding Linux or Intel builds later.
- **Impact:** more modular outputs and fewer duplicated definitions.

### FLK-04 — Deduplicate nixpkgs configuration

- **What changed:** you define `nixpkgs.config` multiple times (in darwin and in outputs).
- **Why it matters:** diverging configs cause inconsistent behaviour between system and user builds.
- **Impact:** single source of truth for `allowUnfree`, overlays, and experimental settings.

### FLK-05 — Introduce host construction helpers

- **What changed:** using a helper like `mkDarwinHost` or `lib.genAttrs` keeps per-host configuration concise.
- **Why it matters:** prevents copy/paste as you add hosts or test builds.
- **Impact:** easier maintenance and cleaner diffs.

### HB-01 — Refresh Homebrew activation options

- **What changed:** `homebrew.onActivation.cleanup` semantics were clarified (`"none"`, `"rm"`, `"zap"`, `"uninstall"`).
- **Why it matters:** ensures cleanup matches your expectations after each rebuild.
- **Impact:** predictable cask management and less churn.

### HB-02 — Enable Brewfile generation

- **What changed:** nix-darwin can now emit a Brewfile when `homebrew.brewFile.enable = true;`.
- **Why it matters:** handy for sharing your setup with non-nix colleagues or recovering with plain Homebrew.
- **Impact:** extra artifact for documentation and disaster recovery.

### HB-03 — Audit Homebrew taps

- **What changed:** custom taps may become unmaintained or redundant.
- **Why it matters:** stale taps slow `brew update` and can error during rebuilds.
- **Impact:** leaner tap list and faster updates.

### SH-01 — Force override conflicting aliases

- **What changed:** `lib.mkForce` explicitly tells Home Manager to override lower-priority definitions.
- **Why it matters:** ensures your `ls` alias survives fish defaults without generating warnings.
- **Impact:** predictable alias behaviour across updates.

### SH-02 — Use modern fish abbreviations

- **What changed:** Fish 4 adds more powerful abbreviations; HM exposes them via `shellAbbrsExtended`.
- **Why it matters:** abbreviations expand smartly and are easier to edit mid-command than aliases.
- **Impact:** faster shell usage with fewer surprises.

### SH-03 — Convert complex helpers into functions

- **What changed:** storing multi-step helpers as HM functions captures dependencies for closure building.
- **Why it matters:** ensures required binaries ship with your profile and keeps alias definitions tidy.
- **Impact:** improved reproducibility of helper commands.

### INT-01 — Integrate secrets handling

- **What changed:** HM now has modules (and patterns) for 1Password CLI integration, including caching and environment exports.
- **Why it matters:** prevents manual `op` calls and ensures secrets load securely on activation.
- **Impact:** consistent secrets access with auditability.

### INT-02 — Manage Aerospace via Home Manager

- **What changed:** `programs.aerospace` exposes `userSettings`, `settingsFile`, and package selection.
- **Why it matters:** centralizes your tiling WM config and validates schema on rebuild.
- **Impact:** easier to tweak keybindings and sync across machines.

### INT-04 — Manage terminal configs

- **What changed:** HM can manage `wezterm.toml`, `alacritty.yml`, etc., via `xdg.configFile` or dedicated modules.
- **Why it matters:** ensures fonts/themes propagate regardless of the installation source.
- **Impact:** consistent terminal experience across devices.

### INT-05 — Use launchd modules for background jobs

- **What changed:** nix-darwin `launchd.daemons` / `launchd.agents` allow you to declare background processes declaratively.
- **Why it matters:** avoids manual `launchctl` commands and ties lifecycle to rebuilds.
- **Impact:** reliable background services (e.g., Podman machine autostart).

### INT-06 — Adopt impermanence patterns

- **What changed:** HM integrates with the `impermanence` module for managing persistent vs ephemeral directories.
- **Why it matters:** lets you keep caches/scratch space volatile while preserving configs.
- **Impact:** cleaner machines and safer experimentation.
