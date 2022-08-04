{ pkgs, config, inputs, ... }: {

  home.packages = with pkgs; [
    any-nix-shell
  ];
  programs.fish = {
    enable = true;
    functions = {
      mcd = ''
        mkdir -p $argv
        cd $argv
      '';
    };
    shellAliases = with pkgs;
      {
        # Nix related
        drb = "darwin-rebuild build --flake ${config.home.user-info.nixConfigDirectory}";
        drs = "TERM=kitty darwin-rebuild switch --flake ${config.home.user-info.nixConfigDirectory}";
        flakeup = "nix flake update ${config.home.user-info.nixConfigDirectory}";
        nb = "nix build";
        nf = "nix flake";

        # Other
        ".." = "cd ..";
        ":q" = "exit";
        cat = "${bat}/bin/bat";

        # g = "${gitAndTools.git}/bin/git";
      };
    shellInit = ''
      any-nix-shell fish --info-right | source
			source /Users/alonzothomas/.local/share/nvim/site/pack/packer/start/nightfox.nvim/extra/nightfox/nightfox_fish.fish
    '';
    # ${pkgs.atuin}/bin/atuin init fish | source
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

}
