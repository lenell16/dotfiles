{ inputs, config, pkgs, lib, ... }: {

  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # environment setup
  environment = {
    systemPackages = with pkgs; [
      pkgs-deprecated-darwin.blender
      gitkraken
      iina
      postman
      pkgs-deprecated-darwin.kitty
      mpv
      vscode
    ];
  };

  fonts = {
    fontDir.enable = true;
  };
  fonts = {
    fonts = with pkgs; [
      powerline-fonts
      fira-code
      fira-mono
      input-fonts
      (nerdfonts.override {
        fonts = [
          "FiraMono"
          "JetBrainsMono"
        ];
      })
    ];
  };

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
    TERMINFO_DIRS = "${pkgs.pkgs-deprecated-darwin.kitty.terminfo.outPath}/share/terminfo";
    TERMINAL = "kitty";
    TERM = "kitty";
  };

  # Auto upgrade nix package and the daemon service.
  # services = {
  #   skhd = {
  #     enable = true;
  #     skhdConfig = (builtins.readFile ../hm/dotfiles/skhd/skhdrc);
  #   };
  # yabai = {
  #   enable = true;
  #   # package = "/usr/local/bin/yabai";
  #   enableScriptingAddition = true;
  #   extraConfig = (builtins.readFile ../hm/dotfiles/yabai/yabairc);
  # };
  # };

  system = {
    activationScripts.postActivation.text = ''
      # Set the default shell as fish for the user. MacOS doesn't do this like nixOS does
      sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish alonzothomas
    '';
  };
}
