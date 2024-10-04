{ inputs, config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    any-nix-shell
    asdf-vm
    azure-cli
    azure-functions-core-tools
    bun
    curl
    fd
    iina
    infisical
    nixd
    nixpkgs-fmt
    protobuf
    ripgrep
    turbo
    uv
    yt-dlp
    #     [ google-cloud-sdk.components.gke-gcloud-auth-plugin ]
    #   )
    #   google-cloud-sdk.withExtraComponents (
    # (
    # )
    # # crystal
    # # gobang
    # ant
    # black
    # cargo
    # cloudflared
    # cocoapods
    # corepack_21
    # deno
    # ffmpeg
    # fx
    # gitflow
    # gitkraken
    # google-cloud-sql-proxy
    # gradle
    # httpie
    # jetbrains.datagrip
    # kubectx
    # lucky-cli
    # maven
    # miller
    # mongodb
    # nodejs_20
    # nodePackages.eslint_d
    # nodePackages.fixjson
    # nodePackages.pnpm
    # nodePackages.prettier
    # nodePackages.typescript
    # nodePackages.zx
    # overmind
    # pkg-config
    # pkgs.devenv
    # pkgs.ltex-ls
    # pkgs.marksman
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
    # viu
    # watchman
    # wget
    # xplr
    # yarn
  ];
}
