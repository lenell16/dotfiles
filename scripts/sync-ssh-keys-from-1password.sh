#!/usr/bin/env bash
# Pull SSH *private* keys out of 1Password into ~/.ssh (runs whenever you execute it — no Nix activation).
#
# Prerequisites:
#   • 1Password CLI installed (e.g. brew install --cask 1password-cli → /opt/homebrew/bin/op)
#   • Signed in: run `op signin` or use desktop app “Integrate with 1Password CLI” while unlocked
#
# Find references:
#   op item list | rg -i github
#   op item get "Title" --format json | jq '.fields[] | {label,id}'
#
# Usage:
#   ./scripts/sync-ssh-keys-from-1password.sh
#
# Optional overrides (no file edits):
#   REF_GITHUB="op://..." REF_TRIBBLE_GITHUB="op://..." ./scripts/sync-ssh-keys-from-1password.sh

set -euo pipefail

# --- Edit these (or export the same variable names before running). ---
# For 1Password SSH Key items you can use item IDs (stable if titles collide).
# Example:
#   REF_GITHUB='op://Personal/dafxy6eq5y3ropbfnjbx4ks5yy/private key'
#   REF_TRIBBLE_GITHUB='op://Personal/dgptzbjnogy2ade5q6la5rpdoy/private key'
# The script tries ?ssh-format=openssh automatically if you omit it.
: "${REF_GITHUB:=}"
: "${REF_TRIBBLE_GITHUB:=}"

SSH_DIR="${SSH_DIR:-$HOME/.ssh}"
OUT_GITHUB="${OUT_GITHUB:-$SSH_DIR/Github}"
OUT_TRIBBLE="${OUT_TRIBBLE:-$SSH_DIR/tribble-github}"

export OP_BIOMETRIC_UNLOCK_ENABLED="${OP_BIOMETRIC_UNLOCK_ENABLED:-true}"

pick_op() {
    if [[ -n "${OP_BIN_OVERRIDE:-}" && -x "${OP_BIN_OVERRIDE}" ]]; then
        echo "${OP_BIN_OVERRIDE}"
        return 0
    fi
    local c
    for c in /opt/homebrew/bin/op /usr/local/bin/op; do
        if [[ -x "$c" ]]; then
            echo "$c"
            return 0
        fi
    done
    if command -v op &>/dev/null; then
        command -v op
        return 0
    fi
    echo "sync-ssh-keys-from-1password: no 'op' found (install 1password-cli cask or put op on PATH)" >&2
    return 1
}

restore_cli_session() {
    local cache="$HOME/.cache/op/session"
    local acctfile="$HOME/.cache/op/account"
    if [[ -z "${OP_SESSION:-}" && -r "$cache" ]]; then
        OP_SESSION="$(tr -d '\n' <"$cache")"
        export OP_SESSION
    fi
    if [[ -z "${OP_ACCOUNT:-}" && -r "$acctfile" ]]; then
        OP_ACCOUNT="$(tr -d '\n' <"$acctfile")"
        export OP_ACCOUNT
    fi
}

sync_one() {
    local dest=$1 ref=$2 name=$3
    if [[ -z "$ref" ]]; then
        echo "sync-ssh-keys-from-1password: skip $name (no REF set)"
        return 0
    fi
    local tmp
    tmp="$(mktemp "${dest}.tmp.XXXXXX")"

    # 1Password SSH Key items default to PKCS#8 in `op read`; OpenSSH needs ?ssh-format=openssh.
    local tries=()
    if [[ "$ref" != *\?ssh-format=* ]]; then
        tries+=("${ref}?ssh-format=openssh")
    fi
    tries+=("$ref")

    local read_ok=1 try
    for try in "${tries[@]}"; do
        if "${OP_BIN:?}" read "$try" >"$tmp" 2>/dev/null; then
            read_ok=0
            break
        fi
    done
    if [[ "$read_ok" -ne 0 ]]; then
        rm -f "$tmp"
        echo "sync-ssh-keys-from-1password: op read failed for $name — check ref and sign-in." >&2
        return 1
    fi

    chmod 600 "$tmp"
    mv -f "$tmp" "$dest"

    if ssh-keygen -y -f "$dest" >"${dest}.pub.tmp" 2>/dev/null; then
        chmod 644 "${dest}.pub.tmp"
        mv -f "${dest}.pub.tmp" "${dest}.pub"
    fi

    echo "sync-ssh-keys-from-1password: wrote $dest (+ ${dest}.pub if derivable)"
}

main() {
    if [[ -z "$REF_GITHUB" && -z "$REF_TRIBBLE_GITHUB" ]]; then
        echo "sync-ssh-keys-from-1password: set REF_GITHUB / REF_TRIBBLE_GITHUB in this script (or export them)." >&2
        exit 1
    fi

    mkdir -p "$SSH_DIR"
    OP_BIN="$(pick_op)"

    restore_cli_session

    if ! "${OP_BIN}" whoami &>/dev/null; then
        echo "sync-ssh-keys-from-1password: not signed in to 1Password CLI (try: op signin)" >&2
        exit 1
    fi

    local ok=0
    if [[ -n "$REF_GITHUB" ]]; then
        sync_one "$OUT_GITHUB" "$REF_GITHUB" "Github (personal)" || ok=1
    fi
    if [[ -n "$REF_TRIBBLE_GITHUB" ]]; then
        sync_one "$OUT_TRIBBLE" "$REF_TRIBBLE_GITHUB" "tribble-github (work)" || ok=1
    fi

    exit "$ok"
}

main "$@"
