{ inputs, lib, ... }: {
  nixpkgs.overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import inputs.stable { system = prev.system; };
    })
    inputs.neovim-overlay.overlay
  ];
}
