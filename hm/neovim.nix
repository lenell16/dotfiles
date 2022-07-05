{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      neovim-nightly
    ];
  };
}
