{ config, pkgs, ... }:

{
	home.file = {
		".mackup.cfg".source = ./mackup/mackup.cfg;
    ".npmrc".source = ./npmrc;
    ".ngrok2" = {
      source = ./ngrok2;
      recursive = true;
    };
  };
  xdg.configFile = {
    nvim = {
      source = ./nvim;
      recursive = true;
    };
    gh = {
      source = ./gh;
      recursive = true;
    };
    "skhd/skhdrc" = {
      source = ./skhd/skhdrc;
      executable = true;
    };
   "yabai/yabairc" = {
      source = ./yabai/yabairc;
      executable = true;
    };
    kitty = {
      source = ./kitty;
      recursive = true;
    };
  };
}
