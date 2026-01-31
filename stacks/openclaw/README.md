# OpenClaw

Personal AI assistant running in Docker. Cloned and built from the [OpenClaw repository](https://github.com/openclaw/openclaw).

## Services

- **openclaw-gateway** — Main gateway service, exposed on ports `18789` (gateway) and `18790` (bridge)
- **openclaw-cli** — Interactive CLI for onboarding and management

## Setup

```bash
cd stacks/openclaw

# Create the host directories for config and workspace
mkdir -p ~/.openclaw/workspace

# Build the image (clones and compiles OpenClaw from source)
docker compose build

# Run onboarding to configure keys/token
docker compose run --rm openclaw-cli onboard

# Start the gateway
docker compose up -d openclaw-gateway
```

The gateway will be available at `http://127.0.0.1:18789/`.

The container runs as your host user's UID/GID (via the `$UID` and `$GID` environment variables) so that mounted volumes are writable without permission issues.

## Rebuilding

To force a fresh clone of the OpenClaw repo (e.g. after an upstream update):

```bash
docker compose build --build-arg CACHE_DATE=$(date)
```

## Environment Variables

These can be set in a `.env` file alongside the docker-compose.yml:

| Variable | Description | Default |
|---|---|---|
| `OPENCLAW_GATEWAY_TOKEN` | Gateway auth token (generated during onboard) | — |
| `CLAUDE_AI_SESSION_KEY` | Claude AI session key | — |
| `CLAUDE_WEB_SESSION_KEY` | Claude web session key | — |
| `CLAUDE_WEB_COOKIE` | Claude web cookie | — |
| `UID` | Host user ID for container process | `1000` |
| `GID` | Host group ID for container process | `1000` |
| `OPENCLAW_GATEWAY_PORT` | Gateway port | `18789` |
| `OPENCLAW_BRIDGE_PORT` | Bridge port | `18790` |
| `OPENCLAW_GATEWAY_BIND` | Gateway bind mode | `lan` |
