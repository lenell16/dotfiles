{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./brew.nix
    ./system-defaults.nix
  ];
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.computerName = "ZoBookPro";
  networking.hostName = "ZoBookPro";
  networking.knownNetworkServices = [
    "Wi-Fi"
  ];
  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  users.users.alonzothomas.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
      home-manager
      warp-terminal
      ngrok
      _1password-cli
      # zed-editor
      transmission_4
      # teams
      # _1password-gui
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/Developer/personal/my-nix";
  services = {
    # skhd = {
    #   enable = true;
    #   skhdConfig = (builtins.readFile ../hm/dotfiles/skhd/skhdrc);
    # };
    # yabai = {
    #   enable = true;
    #   # package = "/usr/local/bin/yabai";
    #   enableScriptingAddition = true;
    #   extraConfig = (builtins.readFile ../hm/dotfiles/yabai/yabairc);
    # };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = { nixpkgs = "${inputs.nixpkgs}"; };
    settings = {
      "extra-experimental-features" = [
        "nix-command"
        "flakes"
      ];
      cores = 8;
    };
    extraOptions = ''
      builders = @/etc/nix/machines
    '';
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh.enable = true; # default shell on catalina
    fish.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system = {
    activationScripts.postActivation.text = ''
      # Set the default shell as fish for the user. MacOS doesn't do this like nixOS does
      sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish alonzothomas
    '';
  };

  fonts.packages = with pkgs; [
    powerline-fonts
    fira-code
    fira-mono
    input-fonts
    monaspace
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
  ];
}
