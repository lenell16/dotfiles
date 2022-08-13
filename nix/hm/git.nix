{ pkgs, config, inputs, ... }: {
  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    git = {
      enable = true;
      userName = "lenell16";
      userEmail = "lenell16@gmail.com";
      includes = [
        {
          path = "${inputs.gitalias}/gitalias.txt";
        }
      ];
      extraConfig = {
				push = {
					autoSetupRemote = true;
				};
        init = {
          defaultBranch = "main";
        };
      };
    };

    gitui = {
      enable = true;
    };

    lazygit.enable = true;
  };
}
