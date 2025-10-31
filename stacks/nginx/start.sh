#!/bin/bash
set -e

# Start cloudflared tunnel in the background
echo "Starting Cloudflare Tunnel..."
cloudflared tunnel --config /etc/cloudflared/config.yml run &

# Store cloudflared PID
CLOUDFLARED_PID=$!

# Function to handle shutdown gracefully
shutdown() {
    echo "Shutting down..."
    kill -TERM "$CLOUDFLARED_PID" 2>/dev/null || true
    nginx -s quit
    wait "$CLOUDFLARED_PID" 2>/dev/null || true
    exit 0
}

# Trap SIGTERM and SIGINT
trap shutdown SIGTERM SIGINT

# Wait a moment for cloudflared to start
sleep 2

# Start nginx in the foreground
echo "Starting nginx..."
nginx -g "daemon off;" &

# Store nginx PID
NGINX_PID=$!

# Wait for nginx to exit
wait "$NGINX_PID"
