{ config, lib, pkgs, ... }: {
  user.name = "alonzothomas";
  hm = { imports = [ ./hm/personal.nix ]; };
}