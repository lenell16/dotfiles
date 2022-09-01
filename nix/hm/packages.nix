{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
			ant
      black
      cargo
      cloudflared
      cloud-sql-proxy
      cocoapods
      # crystal_1_2
      curl
      pkgs-stable-darwin.deno
      fd
      ffmpeg
      fx
      gitflow
      gitkraken
      gobang
      google-cloud-sdk
			gradle
      httpie
      kubectx
      # lucky-cli
			maven
      miller
      # mongodb
      ngrok
      nixpkgs-fmt
      nodejs-16_x
      nodePackages.eslint_d
      nodePackages.fixjson
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.typescript
      nodePackages.zx
      overmind
      pkg-config
      pkgs-stable-darwin.procs
      ripgrep
      rustc
      rustfmt
      sd
      selene
      shellcheck
      shfmt
      streamlink
      stylua
      tree
      unison-ucm
      vault
      watchman
      wget
      viu
      xplr
      yarn
      yt-dlp
    ];
  };
}
