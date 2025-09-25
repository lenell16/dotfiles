{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  podmanMachineName = "podman-machine-default";

  containersToAutostart = [
    "ds9-postgres"
  ];

  podmanAutostartScript = pkgs.writeShellScript "podman-machine-autostart" ''
    set -euo pipefail

    machine_name="${podmanMachineName}"

    echo "Ensuring Podman machine ''${machine_name} is running..."

    if ! ${pkgs.podman}/bin/podman machine inspect "''${machine_name}" >/dev/null 2>&1; then
      echo "Podman machine ''${machine_name} not found; skipping container autostart."
      exit 0
    fi

    ${pkgs.podman}/bin/podman machine start "''${machine_name}" >/dev/null 2>&1 || true

    attempt=0
    until ${pkgs.podman}/bin/podman info >/dev/null 2>&1; do
      attempt=$((attempt + 1))
      if [ "''${attempt}" -ge 15 ]; then
        echo "Timed out waiting for Podman machine ''${machine_name} to become ready; skipping container autostart."
        exit 0
      fi
      ${pkgs.coreutils}/bin/sleep 2
    done

    echo "Podman machine ''${machine_name} is ready; checking containers to start."

    ${lib.concatStringsSep "\n\n    " (map (container: ''
    if ${pkgs.podman}/bin/podman container exists "${container}"; then
      echo "Starting container ${container}"
      ${pkgs.podman}/bin/podman start "${container}"
    else
      echo "Container ${container} not found; skipping."
    fi
    '') containersToAutostart)}
  '';
in

{
  imports = [
    ./brew.nix
    ./system-defaults.nix
  ];

  # Network configuration
  networking = {
    # DNS servers (Cloudflare and Google)
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    # Network service names that should be in the list of known network services
    knownNetworkServices = [
      "Wi-Fi"
    ];
  };

  # Set system hostname (using both legacy and modern settings)
  networking.computerName = "ZoBookPro"; # Legacy setting
  networking.hostName = "ZoBookPro"; # Legacy setting

  # Note: These newer settings might need to be adjusted based on your nix-darwin version
  # Using the proper location for hostname settings which may vary by version
  # For now, we'll rely on the networking.* versions which are known to work
  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  users = {
    knownUsers = [
      "alonzothomas"
    ];

    users.alonzothomas = {
      uid = 501;
      home = "/Users/alonzothomas";
      shell = pkgs.fish;
    };
  };

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    # System tools
    home-manager # Home manager CLI

    # Terminal & CLI tools (1Password provided via programs._1password)

    # Network utilities
    ngrok # Tunnel local servers
    transmission_4 # Torrent client
  ];

  # Global environment variables and profile configuration
  environment.profiles = lib.mkAfter [
    "/opt/homebrew"
  ];

  environment.variables = {
    PKG_CONFIG_PATH = [
      "/opt/homebrew/lib/pkgconfig"
      "/opt/homebrew/share/pkgconfig"
    ];
  };

  environment.darwinConfig = "$HOME/Developer/personal/dotfiles";

  nix.enable = false;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh.enable = true; # default shell on catalina
    fish.enable = true;
    _1password = {
      enable = true;
    };
    "_1password-gui" = {
      enable = true;
    };
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
    # Extend here with additional services (e.g., `login`) if we want biometric auth elsewhere.
  };

  # Launch agents for background services
  launchd.user.agents.podman-machine = {
    serviceConfig = {
      Label = "local.podman.machine.autostart";
      ProgramArguments = [ "${podmanAutostartScript}" ];
      RunAtLoad = true;
      StandardOutPath = "/Users/alonzothomas/Library/Logs/podman-machine.log";
      StandardErrorPath = "/Users/alonzothomas/Library/Logs/podman-machine.err";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.primaryUser = "alonzothomas";

  # System-wide fonts
  fonts.packages = with pkgs; [
    # Monospace/coding fonts
    fira-code # Popular coding font with ligatures
    fira-mono # Monospace version of Fira
    input-fonts # Highly customizable coding font
    monaspace # GitHub's modern monospace font family

    # Nerd fonts (with icons)
    nerd-fonts.fira-mono # Fira Mono with Nerd Font icons
    nerd-fonts.jetbrains-mono # JetBrains Mono with Nerd Font icons

    # Special purpose fonts
    powerline-fonts # Terminal fonts with powerline symbols
  ];
}
