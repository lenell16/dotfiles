{ pkgs, inputs, ... }: {
  programs = {
    kitty = {
      package = pkgs.kitty;
      enable = true;
      settings = {
        macos_option_as_alt = true;
      };
      extraConfig = ''
        include ${inputs.rose-pine-kitty}/dist/rose-pine-moon.conf
      '';
    };
  };
}
