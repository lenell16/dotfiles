# Sync OpenSSH *private* keys from 1Password into ~/.ssh on each home-manager switch.
#
# Vault layout (example): SSH-type item or generic item with a concealed field holding the PEM /
# OpenSSH private key text. Find references with:
#   op item list | rg -i github
#   op item get "<title>" --format json | jq '.fields[] | {label,id}'
# Typical reference shape: op://<vault>/<item title>/<field label>
#
# Turn off 1Password's "SSH agent" integration if you no longer want it to intercept ssh.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.home) homeDirectory;

  # Empty string = skip that key (until you set a real op:// reference).
  sshKeysFrom1Password = lib.filterAttrs (_: ref: ref != "") {
    "Github" = "";
    "tribble-github" = "";
  };

  syncCalls = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: ref: "sync_one ${lib.escapeShellArg name} ${lib.escapeShellArg ref}"
    ) sshKeysFrom1Password
  );

  syncBin = pkgs.writeShellScriptBin "sync-ssh-keys-from-op" ''
    set -euo pipefail

    # sudo darwin-rebuild sets HOME=/var/root — force your real profile so ~/.cache/op matches fish op-relogin.
    HOME_FIXED=${lib.escapeShellArg homeDirectory}
    export HOME="$HOME_FIXED"
    export OP_CONFIG_DIR="$HOME_FIXED/.config/op"

    # Prefer Homebrew op first; 1Password desktop integration targets those binaries on macOS.
    OP_BIN=""
    for candidate in /opt/homebrew/bin/op /usr/local/bin/op "${lib.getExe pkgs._1password-cli}"; do
      if [[ -x "$candidate" ]]; then
        OP_BIN="$candidate"
        break
      fi
    done
    if [[ -z "$OP_BIN" ]]; then
      echo "sync-ssh-keys-from-op: no op executable found" >&2
      exit 1
    fi

    export OP_BIOMETRIC_UNLOCK_ENABLED=true

    SSH_DIR="$HOME_FIXED/.ssh"
    mkdir -p "$SSH_DIR"

    OP_SESSION_CACHE="$HOME_FIXED/.cache/op/session"
    if [[ -z "''${OP_SESSION:-}" && -r "$OP_SESSION_CACHE" ]]; then
      OP_SESSION="$(tr -d '\n' <"$OP_SESSION_CACHE")"
      export OP_SESSION
    fi

    OP_ACCOUNT_CACHE="$HOME_FIXED/.cache/op/account"
    if [[ -z "''${OP_ACCOUNT:-}" && -r "$OP_ACCOUNT_CACHE" ]]; then
      OP_ACCOUNT="$(tr -d '\n' <"$OP_ACCOUNT_CACHE")"
      export OP_ACCOUNT
    fi

    if ! "$OP_BIN" whoami &>/dev/null; then
      echo "sync-ssh-keys-from-op: no usable 1Password CLI session for HOME=$HOME_FIXED (using: $OP_BIN)." >&2
      echo "  • Run op-relogin once so ~/.cache/op/session and ~/.cache/op/account exist." >&2
      echo "  • Unlock 1Password; Settings → Developer → Integrate with 1Password CLI." >&2
      echo "  • darwin/brew.nix installs the 1password-cli cask (preferred path /opt/homebrew/bin/op)." >&2
      exit 0
    fi

    sync_one() {
      local name="$1" ref="$2"
      local dest="$SSH_DIR/$name"
      local tmp
      tmp="$(mktemp "$dest.tmp.XXXXXX")"
      if ! "$OP_BIN" read "$ref" >"$tmp" 2>/dev/null; then
        echo "sync-ssh-keys-from-op: failed to read ref for $name — check op path in home/ssh-keys-from-op.nix" >&2
        rm -f "$tmp"
        return 0
      fi
      chmod 600 "$tmp"
      mv -f "$tmp" "$dest"
      echo "sync-ssh-keys-from-op: updated $dest"
    }

    ${syncCalls}
  '';
in
{
  home.packages = [
    pkgs._1password-cli
    syncBin
  ];

  home.activation.syncSshKeysFrom1Password = lib.hm.dag.entryAfter [ "refreshOpSession" ] ''
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.ssh"
    $DRY_RUN_CMD ${syncBin}/bin/sync-ssh-keys-from-op
  '';
}
