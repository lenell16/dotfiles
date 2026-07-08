# dbhub-tribble — Arcane project

Remote DBHub MCP for Tribble + Presenton databases. Runs on Umbrel via Arcane with a Tailscale sidecar.

## Project files

| File | Purpose |
|------|---------|
| `compose.yaml` | Tailscale sidecar + DBHub (HTTP on 127.0.0.1:8085) |
| `serve.json` | Tailscale Serve → proxy HTTPS to DBHub |
| `dbhub.toml` | Database sources and MCP tools |
| `.env.example` | Required env var names (copy to Arcane Environment) |
| `secrets/` | SSH tunnel PEM keys (gitignored) |

## Before deploy

### 1. SSH keys

Copy into `secrets/` (create the directory on Umbrel / in Arcane):

```bash
cp ~/Developer/tribble/tunnel-keys/vm-prod-pg-tunnel_key.pem arcane/dbhub-tribble/secrets/
cp ~/Developer/tribble/tunnel-keys/vm-staging-pg-tunnel_key.pem arcane/dbhub-tribble/secrets/
chmod 600 secrets/*.pem
```

### 2. Tailscale auth key

[Admin → Keys](https://login.tailscale.com/admin/settings/keys): reusable, **non-ephemeral**, tag as needed.

### 3. Secrets (Arcane Environment)

Paste values from 1Password (see `.env.example`). Do not commit `.env`.

```bash
op read "op://Personal/Tribble DB Prod/password"
op read "op://Personal/Tribble DB Staging/password"
op read "op://Personal/Tribble DB Test/password"
op read "op://Personal/Presenton DB Prod/credential"
op read "op://Personal/Presenton DB Staging/credential"
op read "op://Personal/Presenton DB Test/credential"
```

Presenton URLs must use `postgresql://` (not `postgresql+asyncpg://`).

## Deploy in Arcane

1. Create project **dbhub-tribble**
2. Upload or paste `compose.yaml`, `dbhub.toml`, `serve.json`
3. Upload `secrets/*.pem`
4. Set Environment from `.env.example`
5. Deploy

## After deploy

Tailnet URL (MagicDNS):

```text
https://dbhub-tribble.<your-tailnet>.ts.net
```

Verify:

```bash
curl -s https://dbhub-tribble.<your-tailnet>.ts.net/healthz
```

## Cursor MCP (Mac)

Replace local stdio with remote HTTP:

```bash
cursor --add-mcp '{"name":"dbhub-tribble","url":"https://dbhub-tribble.<your-tailnet>.ts.net/mcp"}'
```

Remove the old stdio entry if it still exists. Restart Cursor.

Requires Tailscale on your Mac (same tailnet).

## Syncing config changes

Server `dbhub.toml` is trimmed for Umbrel (no local DB sources). Mac `home/dbhub.toml` remains the full config including local sources.

When you change remote sources/tools, update both or treat `arcane/dbhub-tribble/dbhub.toml` as the server source of truth and merge back to dotfiles as needed.

## Security

- DBHub HTTP has no auth — access is tailnet-only (`AllowFunnel: false`).
- Bind `--host 127.0.0.1`; only Tailscale Serve exposes the service.
- Optional: Tailscale ACL allowing only your Mac → `dbhub-tribble`.
