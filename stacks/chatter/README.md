# Chatter stack

Chatter (comments, likes and kevsrobots accounts) for kevsrobots.com, served at chatter.kevsrobots.com and
accounts.kevsrobots.com through the Cloudflare tunnel in this stack. Source: https://github.com/kevinmcaleer/chatter

## Update a node

```
cd ~/ClusteredPi/stacks/chatter
docker compose pull && docker compose up -d
```

First time on a node, copy `.env.example` to `.env` and fill it in. Never add `--remove-orphans`.

Build and publish a new image from the Chatter repo first: `docker compose build && docker compose push`.
