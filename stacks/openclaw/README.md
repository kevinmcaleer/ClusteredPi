# OpenClaw

Personal AI assistant running in Docker. Cloned and built from the [OpenClaw repository](https://github.com/openclaw/openclaw).

## Services

- **openclaw-gateway** — Main gateway service, exposed on ports `18789` (gateway) and `18790` (bridge)
- **openclaw-cli** — Interactive CLI for onboarding and management

## Setup

```bash
cd stacks/openclaw

# Build the image
docker compose build

# Run onboarding to configure keys/token
docker compose run --rm openclaw-cli onboard

# Start the gateway
docker compose up -d openclaw-gateway
```

The gateway will be available at `http://127.0.0.1:18789/`.

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
| `OPENCLAW_CONFIG_DIR` | Host path for config | `~/.openclaw` |
| `OPENCLAW_WORKSPACE_DIR` | Host path for workspace | `~/.openclaw/workspace` |
| `OPENCLAW_GATEWAY_PORT` | Gateway port | `18789` |
| `OPENCLAW_BRIDGE_PORT` | Bridge port | `18790` |
| `OPENCLAW_GATEWAY_BIND` | Gateway bind mode | `lan` |
