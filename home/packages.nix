{ inputs, config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # pkgs.devenv
    # pkgs.ltex-ls
    # pkgs.marksman
    # pkgs.nixd
    any-nix-shell
    bun
    azure-cli
    ripgrep
    # ant
    # black
    # cargo
    # cloudflared
    # cocoapods
    # corepack_21
    # # crystal
    curl
    # deno
    fd
    # ffmpeg
    # fx
    # gitflow
    # gitkraken
    # # gobang
    # (
    #   google-cloud-sdk.withExtraComponents (
    #     [ google-cloud-sdk.components.gke-gcloud-auth-plugin ]
    #   )
    # )
    # google-cloud-sql-proxy
    # gradle
    # httpie
    iina
    # jetbrains.datagrip
    # kubectx
    # lucky-cli
    # maven
    # miller
    # mongodb
    nixpkgs-fmt
    nodejs_20
    # nodePackages.eslint_d
    # nodePackages.fixjson
    # nodePackages.pnpm
    # nodePackages.prettier
    # nodePackages.typescript
    # nodePackages.zx
    # overmind
    # pkg-config
    # procs
    # rustc
    # rustfmt
    # sd
    # selene
    # shellcheck
    # shfmt
    # streamlink
    # stylua
    # tree
    # unison-ucm
    # vault
    # watchman
    # wget
    # viu
    # xplr
    # yarn
    yt-dlp
  ];
}
