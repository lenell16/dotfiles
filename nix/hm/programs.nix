{ pkgs, config, inputs, ... }: {
  home = {
    sessionPath = [
      "/Users/alonzothomas/.cargo/bin"
      "/opt/local/bin"
      "/opt/local/sbin"
    ];
  };
  programs = {
    # atuin = {
    #   enable = true;
    # };

    bat.enable = true;

    bottom.enable = true;

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    go.enable = true;

    jq.enable = true;

    mpv.enable = true;

    nnn.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        cmd_duration.disabled = true;
        gcloud.disabled = true;
      };
    };

    tmux.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
