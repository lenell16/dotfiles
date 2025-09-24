# Fish shell aliases organized by category
{ config, pkgs, lib, ... }:

let
  # Commands wrapped with common flags
  exa = "${pkgs.eza}/bin/eza";
  git = "${pkgs.gitAndTools.git}/bin/git";

  # Nix rebuild commands
  nixConfigDir = "~/Developer/personal/dotfiles";
  darwinRebuild = "sudo darwin-rebuild switch --flake ${nixConfigDir}";
  hmSwitch = "home-manager switch --flake ${nixConfigDir}#alonzothomas";
  nixFlakeUpdate = "pushd ${nixConfigDir} && nix flake update && popd";
  nixSystemCheck = "nix flake check ${nixConfigDir}";
in
{
  # This file defines shell aliases for fish shell
  # Aliases are organized by category for better maintainability

  programs.fish = {
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      
      # Common commands
      ls = "${exa}";
      ll = "${exa} -l";
      la = "${exa} -la";

      # Nix system management - rebuild commands
      drs = "${darwinRebuild}";                   # Darwin rebuild switch
      hmrs = "${hmSwitch}";                       # Home-manager rebuild switch
      nrs = "${darwinRebuild} && ${hmSwitch}";    # Full system rebuild (darwin + home-manager)
      
      # Nix system management - updates
      nup = "${nixFlakeUpdate}";                  # Update flake dependencies
      npull = "pushd ${nixConfigDir} && git pull && popd";  # Pull latest changes
      
      # Nix system management - maintenance
      ngc = "nix-collect-garbage -d";             # Garbage collection, delete old generations
      ngco = "nix-collect-garbage";               # Garbage collection only, keep generations
      ngcl = "nix-store --gc";                    # Low-level garbage collection
      nopt = "nix-store --optimize";              # Optimize store by hardlinking identical files
      
      # Nix system management - info and debugging
      nqr_sys = "nix-store --query --requisites /run/current-system | sort | uniq";  # Query system dependencies
      nqr = "nix why-depends";                    # Explain why X depends on Y
      nd_shell = "nix develop";                   # Enter development shell
      nlk = "nix run nixpkgs#nix-tree";           # Show dependency tree using nix-tree
      nck = "${nixSystemCheck}";                  # Run flake checks
      
      # Nix system management - generations
      ngl = "nix profile history --profile /nix/var/nix/profiles/system";  # List system generations
      ngld = "sudo darwin-rebuild list-generations";  # List darwin generations
      nhlg = "home-manager generations";         # List home-manager generations
      
      # Nix system management - NixOS related (for multi-system compatibility)
      nixos-switch = "sudo nixos-rebuild switch --flake ${nixConfigDir}";  # NixOS rebuild switch
      
      # Git shortcuts
      g = "${git}";
      gs = "${git} status";
      ga = "${git} add";
      gc = "${git} commit";
      gp = "${git} push";
      gl = "${git} pull";
      gco = "${git} checkout";
      gd = "${git} diff";
      gb = "${git} branch";
      glg = "${git} log --graph --oneline --decorate";
      
      # Utility
      ":q" = "exit";
      
      # Quick edits
      n = "$EDITOR";                                # Start editor
      config = "cd ${nixConfigDir} && $EDITOR";     # Edit Nix config
      
      # Nix configuration management
      ncd = "cd ${nixConfigDir}";                   # Go to nix config dir
      nhome = "$EDITOR ${nixConfigDir}/home/home.nix";     # Edit home.nix
      ndarwin = "$EDITOR ${nixConfigDir}/darwin/darwin.nix"; # Edit darwin.nix
      naliases = "$EDITOR ${nixConfigDir}/home/aliases.nix"; # Edit aliases.nix
      npackages = "$EDITOR ${nixConfigDir}/home/packages.nix"; # Edit packages.nix
      nbrew = "$EDITOR ${nixConfigDir}/darwin/brew.nix";   # Edit brew.nix
      
      # Health check
      nix-health = "echo 'Running Nix health checks...' && ${nixSystemCheck} && echo 'All checks passed!'";
    };
    
    # Fish abbreviations (expand when you press space)
    shellAbbrs = {
      # Basic nix commands
      nf = "nix flake";
      nb = "nix build";
      nr = "nix run";
      ns = "nix shell";
      nd = "nix develop";
      
      # Quick system management
      nsu = "${nixFlakeUpdate} && ${darwinRebuild}";    # Update and rebuild in one go
      drb = "${darwinRebuild}";                        # Shorter darwin rebuild
      hms = "${hmSwitch}";                             # Shorter home-manager switch
      
      # Package management
      nq = "nix-store --query";
      ni = "nix-env -iA";                              # Install package
      nu = "nix-env -u";                               # Update packages
      ne = "nix-env -e";                               # Uninstall package
      nl = "nix-env -q";                               # List packages
      
      # Search
      nse = "nix search nixpkgs";                      # Search nixpkgs
    };
  };
}
