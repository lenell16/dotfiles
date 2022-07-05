{ pkgs, config, inputs, ... }: {

  home.packages = with pkgs; [
    amp
    micro
  ];

  programs = {
    helix = {
      enable = true;
    };

    kakoune = {
      enable = true;
    };
  };
}
