{ pkgs, config, inputs, ... }: {

  home.packages = with pkgs; [
    any-nix-shell
  ];
  programs.fish = {
    enable = true;
    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
    # interactiveShellInit = ''
    #   ${pkgs.atuin}/bin/atuin init fish | source
    # '';
  };

}
