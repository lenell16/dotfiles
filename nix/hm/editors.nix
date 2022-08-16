{ pkgs, config, inputs, ... }: {

  home.packages = with pkgs; [
    amp
    micro
  ];

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "tokyonight_storm";
      };
    };

    kakoune = {
      enable = true;
    };
  };
}
