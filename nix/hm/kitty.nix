{ pkgs, inputs, ... }: {
  programs = {
    kitty = {
      package = pkgs.kitty;
      enable = true;
      settings = {
        macos_option_as_alt = true;
        inactive_text_alpha = "0.5";
      };
      keybindings = {
        /* "shift+enter" = "send_text all \x1b[13;2u"; */
      };
      extraConfig = ''
        include /Users/alonzothomas/.local/share/nvim/site/pack/packer/start/nightfox.nvim/extra/nightfox/nightfox_kitty.conf 
      '';
    };
  };
}
