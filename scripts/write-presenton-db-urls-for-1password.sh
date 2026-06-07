#!/usr/bin/env bash
# Fetch Presenton DATABASE URLs from Azure Key Vault and write a dotenv file for
# copying into 1Password (DBHub op:// references in home/home.nix).
#
# Prerequisites: az login
#
# Usage:
#   ./scripts/write-presenton-db-urls-for-1password.sh
#   OUTPUT=~/Desktop/presenton-db-urls.env ./scripts/write-presenton-db-urls-for-1password.sh
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT="${OUTPUT:-"$ROOT_DIR/secrets/presenton-db-urls.for-1password.env"}"

kv_get() {
  local vault="$1"
  az keyvault secret show --vault-name "$vault" --name PRESENTON-DATABASE-URL --query value -o tsv |
    tr -d '\r\n' |
    sed 's|^postgresql+asyncpg://|postgresql://|'
}

emit_line() {
  python3 -c 'import json,sys; print(sys.argv[1] + "=" + json.dumps(sys.argv[2]))' "$1" "$2"
}

tmp="$(mktemp)"
cleanup() { rm -f "$tmp"; }
trap cleanup EXIT

{
  echo "# Presenton PostgreSQL URLs for 1Password"
  echo "# Copy each value into a 1Password item (field: credential)."
  echo "# Item titles (match home.nix op:// references):"
  echo "#   Presenton DB Test | Presenton DB Staging | Presenton DB Prod"
  echo "# DBHub uses postgresql:// (not postgresql+asyncpg://)."
  echo "# Local stack: only when presenton docker compose is up (host port 5433)."
  echo ""
  emit_line PRESENTON_LOCAL_DATABASE_URL "postgresql://presenton:presenton@localhost:5433/presenton"
  echo ""
  emit_line PRESENTON_TEST_DATABASE_URL "$(kv_get kv-tribble-test)"
  emit_line PRESENTON_STAGING_DATABASE_URL "$(kv_get kv-tribble-staging)"
  emit_line PRESENTON_PROD_DATABASE_URL "$(kv_get kv-tribble-prod)"
} >"$tmp"

mkdir -p "$(dirname "$OUTPUT")"
mv "$tmp" "$OUTPUT"
trap - EXIT
chmod 600 "$OUTPUT" 2>/dev/null || true

echo "Wrote $OUTPUT (mode 600). Create 1Password items, then: hmrs"
