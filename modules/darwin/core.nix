{ inputs, config, pkgs, lib, ... }:
let prefix = "/run/current-system/sw/bin";
in
{
  # environment setup
  environment = {
    loginShell = pkgs.fish;
    etc = { darwin.source = "${inputs.darwin}"; };

    systemPackages = with pkgs; [
      stable.blender
      gitkraken
      iina
      postman
    ];
  };

  fonts = {
    fontDir.enable = true;
  };
  nix = {
    nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  # auto manage nixbld users with nix darwin
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
    };

    skhd = {
      enable = true;
      skhdConfig = (builtins.readFile ../hm/dotfiles/skhd/skhdrc);
    };
    # yabai = {
    #   enable = true;
    #   # package = "/usr/local/bin/yabai";
    #   enableScriptingAddition = true;
    #   extraConfig = (builtins.readFile ../hm/dotfiles/yabai/yabairc);
    # };
  };

  system = {
    stateVersion = 4;
    activationScripts.postActivation.text = ''
      # Set the default shell as fish for the user. MacOS doesn't do this like nixOS does
      sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish alonzothomas
    '';
  };

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };
}
