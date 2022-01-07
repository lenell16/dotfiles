{ config, pkgs, ... }:

let
	stable = import <stable> {};
in

{
  programs.home-manager.enable = true;
  home = {
    sessionVariables= {
      DOTBARE_DIR = "$HOME/dotfiles";
      DOTBARE_TREE = "$HOME";
    };
    stateVersion = "21.11";
    username = "alonzothomas";
    homeDirectory = "/Users/alonzothomas";
    packages = with pkgs; [
      any-nix-shell
      amp
      stable.blender
      cocoapods
      stable.crystal
      curl
      deno
      fd
      ffmpeg
      fx
      gitflow
      gh
      google-cloud-sdk
      httpie
      kubectx
      stable.lucky-cli
      micro
      miller
      stable.mongodb
      ngrok
      neovim
      nixpkgs-fmt
      nodejs
      nodePackages.pnpm
      openconnect
      overmind
      procs
      ripgrep
      sd
      streamlink
      tree
      vault
      wally-cli
      watchman
      wget
      yarn
      youtube-dl
    ];
  };

	home.file.".npmrc".source = ./dotfiles/npmrc;
	home.file.".ngrok2" = {
    source = ./dotfiles/ngrok2;
    recursive = true;
  };
  xdg.configFile."nvim" = {
    source = ./dotfiles/nvim;
    recursive = true;
  };
  xdg.configFile."gh" = {
    source = ./dotfiles/gh;
    recursive = true;
  };
  xdg.configFile."skhd/skhdrc" = {
    source = ./dotfiles/skhd/skhdrc;
    executable = true;
  };
  xdg.configFile."yabai/yabairc" = {
    source = ./dotfiles/yabai/yabairc;
    executable = true;
  };


  programs = {
    bat.enable = true;

    bottom.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };

    fish = {
      enable = true;
      shellInit = ''
        any-nix-shell fish --info-right | source
      '';
      shellAliases = {
        dotbare = "$HOME/.dotbare/dotbare";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      userName = "lenell16";
      userEmail = "lenell16@gmail.com";
    };

    go.enable = true;

    jq.enable = true;

    lazygit.enable = true;

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

    vscode = {
      enable = true;
      extensions = (with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        denoland.vscode-deno
        tyriar.sort-lines
        arcticicestudio.nord-visual-studio-code
        dbaeumer.vscode-eslint
        alefragnani.project-manager
        eamodio.gitlens
        editorconfig.editorconfig
        esbenp.prettier-vscode
        file-icons.file-icons
        jpoissonnier.vscode-styled-components
        ms-azuretools.vscode-docker
        redhat.vscode-yaml
        tomoki1207.pdf
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-apollo";
          publisher = "apollographql";
          version = "1.19.7";
          sha256 = "1l3zswwlvmk4nw8agjvwjazg7vc5r6hidlpd5crzr3hb4fl247zg";
        }
        {
          name = "atlascode";
          publisher = "atlassian";
          version = "2.9.1";
          sha256 = "0865f8cn950qj2fi1fja1qga6qbs12dsx3x5ws3fpcfbkdd4k1lm";
        }
        {
          name = "turbo-console-log";
          publisher = "ChakrounAnas";
          version = "2.1.7";
          sha256 = "02kzsv6y7hdgrjzqk6sac85n5c0rc81nghkcv9zsyw9krj6ayki4";
        }
        {
          name = "vscode-svgviewer";
          publisher = "cssho";
          version = "2.0.0";
          sha256 = "06swlqiv3gc7plcbmzz795y6zwpxsdhg79k1n3jj6qngfwnv2p6z";
        }
        {
          name = "vscode-jq-playground";
          publisher = "davidnussio";
          version = "4.2.0";
          sha256 = "1nji7lgrbfgrh0rdsnyaz85b69vfw82brn7gvgz99ph249bzrncf";
        }
        {
          name = "viml";
          publisher = "dunstontc";
          version = "0.1.7";
          sha256 = "0r2dpd07lj8icpbl1nvgk08y6s73bzwv6njpj7m4fcapwjjvhb7l";
        }
        {
          name = "moxer-icons";
          publisher = "Equinusocio";
          version = "5.8.0";
          sha256 = "0abiaixwmxr5jpkbxisc51vq8p5wzi2ddr505z8n83jhcmybsyzk";
        }
        {
          name = "vscode-yarn";
          publisher = "gamunu";
          version = "2.0.0";
          sha256 = "0ragrqz6i8zw7rxy06qqln6v5mqjvhz23lc30s7m4f66ccj51fl4";
        }
        {
          name = "remotehub";
          publisher = "GitHub";
          version = "0.17.0";
          sha256 = "168xpz419d5881fz42w6v1dbhjl2wqhsd7zpmw22vd9mk8gq5536";
        }
        {
          name = "jq-syntax-highlighting";
          publisher = "jq-syntax-highlighting";
          version = "0.0.2";
          sha256 = "0q91mr6a6935wnka5iga97lv78g19dlj2rz6qg3ki6w3kdlvw2h7";
        }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.205.0";
          sha256 = "18mr7sy2dkf795i19ycvcpm4agrwfq42zrbi5kvj0lrmkfiw0ni6";
        }
        {
          name = "sqltools";
          publisher = "mtxr";
          version = "0.23.0";
          sha256 = "0gkm1m7jss25y2p2h6acm8awbchyrsqfhmbg70jaafr1dfxkzfir";
        }
        {
          name = "sqltools-driver-pg";
          publisher = "mtxr";
          version = "0.2.0";
          sha256 = "0ws17sna87rs4ihcdj5lzxf8g2nkcgyjpqlafl5kii2c8x364y6j";
        }
        {
          name = "advanced-new-file";
          publisher = "patbenatar";
          version = "1.2.2";
          sha256 = "09a6yldbaz9d7gn9ywkqd96l3pkc0y30b6b02nv2qigli6aihm6g";
        }
        {
          name = "prisma";
          publisher = "Prisma";
          version = "3.3.0";
          sha256 = "0pdvcxslfycspf03brcvc4s7kr2nv8b4d128iz2ab77m2bfd407c";
        }
        {
          name = "vscode-thunder-client";
          publisher = "rangav";
          version = "1.9.1";
          sha256 = "1m642xpym1a80xz0nq4h3y6z6qlvk45y7rlfn00yajylpfgjygig";
        }
        {
          name = "rome";
          publisher = "rome";
          version = "0.0.3";
          sha256 = "1dlndll85qazbrss5gpsnjk6dlh1j6p94kj21q665wrmqq13hjq8";
        }
        {
          name = "vscode-brewfile";
          publisher = "sharat";
          version = "1.0.0";
          sha256 = "1z9mjlwccnn5cs3mwdb4mjv61hw0h7hqqpk4hbn0ppa8dgpfkvzq";
        }
        {
          name = "vscode-fileutils";
          publisher = "sleistner";
          version = "3.4.5";
          sha256 = "0f5n0i337h8bc66zv7j54rl42na09jpcivhs5s5f59g4vavrhfk7";
        }
        {
          name = "quokka-vscode";
          publisher = "WallabyJs";
          version = "1.0.410";
          sha256 = "17xm5gaiv510qiggs8y4rhsjhxasfhaim916kk0k7l3mnw9jyxv0";
        }
        {
          name = "change-case";
          publisher = "wmaurer";
          version = "1.0.0";
          sha256 = "0dxsdahyivx1ghxs6l9b93filfm8vl5q2sa4g21fiklgdnaf7pxl";
        }
        {
          name = "zoombar-vscode";
          publisher = "wraith13";
          version = "1.4.0";
          sha256 = "1ys45bijy3w8smqklkl3s8plb4dbcp90r29s7ca4pk7vy131zx4w";
        }
        {
          name = "vscode-fish";
          publisher = "bmalehorn";
          version = "1.0.24";
          sha256 = "1hi9xixhzpy09fy25j6xhv8k9yahwj9kh8s057xibaaj04lz6i5b";
        }
        {
          name = "gc-excelviewer";
          publisher = "GrapeCity";
          version = "3.0.44";
          sha256 = "07l9vx838cs0j7h8bi5ckkyapi3n5fp93k01c8yw3r5276mx44im";
        }
      ];
      userSettings = {
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };
        "[javascriptreact]" = {
          "editor.formatOnSave" = false;
        };
        "atlascode.bitbucket.explorer.enabled" = true;
        "atlascode.bitbucket.issues.explorerEnabled" = false;
        "atlascode.bitbucket.statusbar.enabled" = false;
        "atlascode.jira.enabled" = true;
        "atlascode.jira.jqlList" = [
          {
            "id" = "fa8cc694-d448-417b-934d-2548f2175342";
            "enabled" = true;
            "name" = "me";
            "query" = "project = \"CX\" AND status != Closed AND assignee = currentUser() AND Sprint in openSprints() ORDER BY statusCategory DESC";
            "siteId" = "88fe7a39-56cc-4591-8c0c-4bb802318829";
            "monitor" = true;
          }
        ];
        "atlascode.jira.statusbar.enabled" = false;
        "breadcrumbs.enabled" = false;
        "diffEditor.ignoreTrimWhitespace" = false;
        "diffEditor.renderSideBySide" = false;
        "editor.bracketPairColorization.enabled" = false;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.fontFamily" = "Fira Code, Menlo, Monaco, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "all";
        "editor.tabSize" = 2;
        "emmet.includeLanguages" = {
          "javascript" = "javascriptreact";
        };
        "eslint.alwaysShowStatus" = true;
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "git.autofetch" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "prettier.requireConfig" = true;
        "projectManager.git.baseFolders" = [ "~/Developer/work" ];
        "security.workspace.trust.untrustedFiles" = "open";
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.defaultLocation" = "view";
        "terminal.integrated.defaultProfile.osx" = "fish";
        "terminal.integrated.fontFamily" = "Fira Mono for Powerline";
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "workbench.colorTheme" = "Nord";
        "workbench.iconTheme" = "moxer-icons";
        "yaml.schemas" = {
          "file:///Users/alonzothomas/.vscode/extensions/atlassian.atlascode/resources/schemas/pipelines-schema.json" = "bitbucket-pipelines.yml";
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
