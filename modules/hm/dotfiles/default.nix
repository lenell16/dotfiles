{ config, pkgs, ... }:

{
  home.file = {
    ".npmrc".source = ./npmrc;
    ".ngrok2" = {
      source = ./ngrok2;
      recursive = true;
    };
  };
  xdg.configFile = {
    xplr = {
      source = ./xplr;
      recursive = true;
    };
    nvim = {
      source = ./nvim;
      recursive = true;
    };
    "yabai/yabairc" = {
      source = ./yabai/yabairc;
      executable = true;
    };
  };
}
