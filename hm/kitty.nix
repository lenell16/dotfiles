{ pkgs, inputs, ... }: {
  programs = {
    kitty = {
      package = pkgs.kitty;
      enable = true;
      settings = {
        macos_option_as_alt = true;
				inactive_text_alpha = "0.5";
      };
      extraConfig = ''
        include /Users/alonzothomas/.local/share/nvim/site/pack/packer/start/nightfox.nvim/extra/nightfox/nightfox_kitty.conf 
      '';
    };
  };
}
