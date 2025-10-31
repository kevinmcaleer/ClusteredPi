# nginx + Cloudflare Tunnel Docker Container

This Docker container combines nginx load balancer with Cloudflare Tunnel to provide secure, reliable traffic routing without requiring port forwarding.

## What's Inside

- **nginx**: Load balancer routing traffic to backend services
- **cloudflared**: Cloudflare Tunnel daemon establishing persistent connections to Cloudflare edge

## Architecture

```
Internet → Cloudflare Edge → Tunnel (4 connections) → nginx Container → Backend Services
```

## Files

### Core Files
- **dockerfile**: Multi-stage build installing nginx + cloudflared
- **docker-compose.yml**: Container orchestration configuration
- **start.sh**: Startup script running both nginx and cloudflared
- **nginx.conf**: nginx load balancer configuration
- **cloudflared-config.yml**: Tunnel routing configuration
- **49b119be-4908-4292-a174-d60d0fa8a8d6.json**: Tunnel credentials (NOT in git)
- **.gitignore**: Prevents committing credentials

### Configuration Files

#### nginx.conf
Standard nginx load balancer configuration routing to:
- Jekyll sites on port 3333
- Chatter API on port 8006
- Various other services

#### cloudflared-config.yml
Tunnel ingress rules:
```yaml
tunnel: 49b119be-4908-4292-a174-d60d0fa8a8d6
credentials-file: /etc/cloudflared/49b119be-4908-4292-a174-d60d0fa8a8d6.json

ingress:
  - hostname: kevsrobots.com
    service: http://192.168.2.2:3333
  - hostname: www.kevsrobots.com
    service: http://192.168.2.2:3333
  - hostname: chatter.kevsrobots.com
    service: http://192.168.2.2:8006
  - service: http_status:404
```

## Building

### Local Build
```bash
docker build -t 192.168.2.1:5000/nginx:latest -f dockerfile .
```

### Push to Registry
```bash
docker push 192.168.2.1:5000/nginx:latest
```

## Deployment

### On Raspberry Pi (192.168.1.4)

```bash
cd /home/pi/ClusteredPi/stacks/nginx
docker compose down
docker compose pull  # Pull latest from registry
docker compose up -d
```

### Check Status
```bash
# Container status
docker compose ps

# View logs (both nginx and cloudflared)
docker logs nginx-nginx_load_balancer-1

# Follow logs
docker logs -f nginx-nginx_load_balancer-1

# Check tunnel connections
docker logs nginx-nginx_load_balancer-1 | grep "Registered tunnel connection"
```

## Restoring from Scratch

If you need to rebuild the entire setup:

### 1. Ensure You Have Credentials
The tunnel credentials file `49b119be-4908-4292-a174-d60d0fa8a8d6.json` must be present in this directory. If lost:

```bash
# On Pi or Mac with existing credentials
sudo cat /etc/cloudflared/49b119be-4908-4292-a174-d60d0fa8a8d6.json > 49b119be-4908-4292-a174-d60d0fa8a8d6.json
```

**IMPORTANT**: Never commit this file to git. It contains secrets.

### 2. Build Image
```bash
cd /Users/Kev/Web/ClusteredPi/stacks/nginx
scp dockerfile nginx.conf cloudflared-config.yml 49b119be-4908-4292-a174-d60d0fa8a8d6.json start.sh pi@192.168.1.4:/home/pi/ClusteredPi/stacks/nginx/

ssh pi@192.168.1.4
cd /home/pi/ClusteredPi/stacks/nginx
docker build -t 192.168.2.1:5000/nginx:latest -f dockerfile .
docker push 192.168.2.1:5000/nginx:latest
```

### 3. Deploy
```bash
docker compose up -d
```

### 4. Verify
```bash
# Check logs for tunnel connections
docker logs nginx-nginx_load_balancer-1 | grep "Registered tunnel connection"

# Should see 4 connections like:
# Registered tunnel connection connIndex=0 ... location=lhr13
# Registered tunnel connection connIndex=1 ... location=lhr15
# Registered tunnel connection connIndex=2 ... location=lhr01
# Registered tunnel connection connIndex=3 ... location=lhr20

# Test sites
curl -I https://kevsrobots.com
curl -I https://chatter.kevsrobots.com/docs
```

## Troubleshooting

### Container Won't Start
```bash
# Check container status
docker compose ps

# View detailed logs
docker logs nginx-nginx_load_balancer-1

# Common issues:
# - Missing credentials file
# - Invalid nginx.conf syntax
# - Port conflicts
```

### Tunnel Not Connecting
```bash
# Check for tunnel errors
docker logs nginx-nginx_load_balancer-1 | grep -i error

# Verify credentials file exists in container
docker exec nginx-nginx_load_balancer-1 ls -la /etc/cloudflared/

# Check DNS records point to tunnel
dig kevsrobots.com
# Should show CNAME to 49b119be-4908-4292-a174-d60d0fa8a8d6.cfargotunnel.com
```

### nginx Errors
```bash
# Test nginx config
docker exec nginx-nginx_load_balancer-1 nginx -t

# Reload nginx (without restarting container)
docker exec nginx-nginx_load_balancer-1 nginx -s reload

# Check backend connectivity
docker exec nginx-nginx_load_balancer-1 curl -I http://192.168.2.2:3333
docker exec nginx-nginx_load_balancer-1 curl -I http://192.168.2.2:8006/docs
```

### Sites Not Accessible
```bash
# 1. Check tunnel is running
docker logs nginx-nginx_load_balancer-1 | grep "Registered tunnel"

# 2. Check DNS propagation
dig kevsrobots.com
dig chatter.kevsrobots.com

# 3. Check Cloudflare tunnel dashboard
# https://dash.cloudflare.com/ → Zero Trust → Access → Tunnels

# 4. Test local nginx directly
curl -I http://192.168.1.4/
```

## Updating Configuration

### Update nginx.conf
```bash
# 1. Edit nginx.conf locally on Mac
vim /Users/Kev/Web/ClusteredPi/stacks/nginx/nginx.conf

# 2. Copy to Pi and rebuild
scp nginx.conf pi@192.168.1.4:/home/pi/ClusteredPi/stacks/nginx/
ssh pi@192.168.1.4
cd /home/pi/ClusteredPi/stacks/nginx
docker build -t 192.168.2.1:5000/nginx:latest -f dockerfile .
docker push 192.168.2.1:5000/nginx:latest
docker compose up -d

# OR reload without rebuild (if container is running):
docker cp nginx.conf nginx-nginx_load_balancer-1:/etc/nginx/nginx.conf
docker exec nginx-nginx_load_balancer-1 nginx -t
docker exec nginx-nginx_load_balancer-1 nginx -s reload
```

### Update Tunnel Routes
```bash
# 1. Edit cloudflared-config.yml locally
vim /Users/Kev/Web/ClusteredPi/stacks/nginx/cloudflared-config.yml

# 2. Rebuild and redeploy (tunnel requires restart to pick up config changes)
scp cloudflared-config.yml pi@192.168.1.4:/home/pi/ClusteredPi/stacks/nginx/
ssh pi@192.168.1.4
cd /home/pi/ClusteredPi/stacks/nginx
docker build -t 192.168.2.1:5000/nginx:latest -f dockerfile .
docker push 192.168.2.1:5000/nginx:latest
docker compose up -d
```

## Security Notes

### Credentials Management
- **49b119be-4908-4292-a174-d60d0fa8a8d6.json**: Contains tunnel credentials
- **NEVER** commit this file to git
- Keep backup in secure location (password manager, encrypted storage)
- If compromised, delete tunnel and create new one:
  ```bash
  cloudflared tunnel delete kevsrobots
  cloudflared tunnel create kevsrobots-new
  # Update configs with new tunnel ID
  ```

### Port Forwarding
With Cloudflare Tunnel:
- **DO NOT** need port forwarding on BT router
- Ports 80/443 can be closed on firewall
- All traffic comes through outbound tunnel connections
- More secure than exposing ports

### Firewall Rules
Container still exposes ports locally for:
- Direct access from local network
- Debugging and testing
- Fallback if tunnel fails

## Monitoring

### Health Checks
```bash
# Container health
docker compose ps

# Tunnel health
docker logs nginx-nginx_load_balancer-1 | tail -20

# nginx health
curl -I http://192.168.1.4/

# Cloudflare dashboard
# https://dash.cloudflare.com/ → Zero Trust → Access → Tunnels → kevsrobots
```

### Metrics
```bash
# Tunnel metrics (inside container)
docker exec nginx-nginx_load_balancer-1 curl http://localhost:20241/metrics

# nginx stub_status (if enabled)
curl http://192.168.1.4/nginx_status
```

### Logs
```bash
# Real-time logs
docker logs -f nginx-nginx_load_balancer-1

# Filter for errors
docker logs nginx-nginx_load_balancer-1 | grep -i error

# Filter for tunnel activity
docker logs nginx-nginx_load_balancer-1 | grep "tunnel\|connection"

# nginx access logs (last 50 lines)
docker logs nginx-nginx_load_balancer-1 | grep -E '^\d+\.\d+\.\d+\.\d+' | tail -50
```

## Benefits

### Compared to Port Forwarding:
✅ **No NAT Table Exhaustion**: 4 persistent outbound connections vs 25,000+ inbound/hour
✅ **Better Security**: No exposed ports on router
✅ **Works with Dynamic IP**: No need to update DNS when ISP changes IP
✅ **Better DDoS Protection**: Cloudflare handles attacks before they reach origin
✅ **Free**: No additional cost for your traffic volume
✅ **Easier Management**: Add services by updating config, no router changes
✅ **More Reliable**: 4 redundant connections to different edge locations

### Compared to systemd Service:
✅ **Reproducible**: Entire config in Docker image
✅ **Portable**: Can deploy to any Docker host
✅ **Easier Updates**: Rebuild image and redeploy
✅ **Better Isolation**: Runs in container, not on host
✅ **Versioned**: Can tag images and rollback if needed

## Tunnel Information

- **Tunnel Name**: kevsrobots
- **Tunnel ID**: 49b119be-4908-4292-a174-d60d0fa8a8d6
- **Created**: 2025-10-30
- **Location**: London edge (lhr13, lhr15, lhr01, lhr20)
- **Protocol**: QUIC
- **Connections**: 4 persistent connections

## DNS Records

All records are CNAME to tunnel:
- kevsrobots.com → 49b119be-4908-4292-a174-d60d0fa8a8d6.cfargotunnel.com
- www.kevsrobots.com → 49b119be-4908-4292-a174-d60d0fa8a8d6.cfargotunnel.com
- chatter.kevsrobots.com → 49b119be-4908-4292-a174-d60d0fa8a8d6.cfargotunnel.com

All proxied through Cloudflare (orange cloud enabled).

## Support

- [Cloudflare Tunnel Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
- [nginx Documentation](https://nginx.org/en/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## Change Log

### 2025-10-30 - Initial Release
- Integrated cloudflared into nginx container
- Migrated from systemd service to Docker
- Documented restoration process
- Added .gitignore for credentials
- Created startup script for both services
