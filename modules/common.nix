{ inputs, config, lib, pkgs, ... }: {
  imports = [ ./primary.nix ./nixpkgs.nix ./overlays.nix ];

  programs.fish.enable = true;

  user = {
    description = "Alonzo Thomas";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.fish;
  };

  # bootstrap home manager using system config
  hm = import ./hm;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # environment setup
  environment = {
    systemPackages = with pkgs; [
      stable.kitty
      mpv
      vscode
    ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${pkgs.path}";
      stable.source = "${inputs.stable}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [
      bashInteractive
      fish
      zsh
    ];
  };

  fonts = {
    fonts = with pkgs; [
      powerline-fonts
      fira-code
      fira-mono
      input-fonts
      (nerdfonts.override { fonts = [
				"FiraMono"
				"JetBrainsMono"
			]; })
    ];
  };
}
