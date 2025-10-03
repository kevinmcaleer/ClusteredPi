# KevsRobots Website - Docker Deployment

Production-ready Docker setup for kevsrobots.com on Raspberry Pi 5 cluster.

## Quick Start

```bash
cd /Users/kev/Web/ClusteredPi/stacks/kevsrobots

# Build
docker-compose build

# Run
docker-compose up -d

# Check status
docker-compose ps
```

## Overview

This setup builds and deploys the KevsRobots website with full optimization:

- ✅ **2 minute builds** (vs 10-22 min previously)
- ✅ **ARM64 native** (Raspberry Pi 5 optimized)
- ✅ **Gzip compression** (70% text reduction)
- ✅ **HTML minification** (30-50% smaller)
- ✅ **Lazy loading** (60-80% fewer initial images)
- ✅ **Browser caching** (instant repeat visits)
- ✅ **Healthcheck** (auto-restart on failure)

## Architecture

### Multi-Stage Build

```
┌─────────────────┐
│  Stage 1        │  Alpine Linux + Git
│  getfiles       │  Clone repository
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Stage 2        │  Ruby 3.2 Alpine
│  jekyll_build   │  Install gems & build site
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Stage 3        │  Nginx Alpine
│  Production     │  Serve optimized site
└─────────────────┘
```

### Build Process

1. **Clone** kevsrobots.com from GitHub (pre-optimized images)
2. **Install** Jekyll and dependencies
3. **Build** static site with minification
4. **Serve** with nginx (gzip + caching enabled)

## Files

```
.
├── dockerfile              # Main Dockerfile (optimized)
├── dockerfile.old          # Backup (Ubuntu-based, slow)
├── docker-compose.yml      # Orchestration config
├── nginx-optimized.conf    # Nginx with gzip + caching
├── .dockerignore          # Build optimization
├── UPGRADE_NOTES.md       # Migration guide
├── DOCKER_OPTIMIZATION.md # Technical details
└── README.md              # This file
```

## Requirements

- **Docker:** 20.10+ (for BuildKit support)
- **Platform:** ARM64 (Raspberry Pi 5 or Apple Silicon)
- **Registry:** 192.168.2.1:5000 (local Docker registry)

## Usage

### Build Locally

```bash
export DOCKER_BUILDKIT=1
docker build -t kevsrobots:latest .
```

### Build with docker-compose

```bash
docker-compose build
```

### Run

```bash
# Start service
docker-compose up -d

# View logs
docker-compose logs -f

# Stop service
docker-compose down
```

### Push to Registry

```bash
docker-compose push
# Or manually:
docker tag kevsrobots:latest 192.168.2.1:5000/kevsrobots:latest
docker push 192.168.2.1:5000/kevsrobots:latest
```

### Deploy to Cluster

```bash
# On your Pi cluster
docker stack deploy -c docker-compose.yml kevsrobots
```

## Image Optimization Workflow

Images are pre-optimized and committed to git. **Do not optimize in Docker.**

### When Adding New Images

1. **Add images** to `/Users/kev/Web/kevsrobots.com/web/assets/img/`

2. **Optimize locally:**
   ```bash
   cd /Users/kev/Web/kevsrobots.com
   python3 optimize_images.py web/assets/img
   ```

3. **Commit optimized images:**
   ```bash
   git add web/assets/img
   git commit -m "Add optimized images for [feature]"
   git push
   ```

4. **Rebuild Docker image** (pulls optimized images from git):
   ```bash
   cd /Users/kev/Web/ClusteredPi/stacks/kevsrobots
   docker-compose build
   ```

### Re-optimize All Images

If you want to change quality settings:

```bash
cd /Users/kev/Web/kevsrobots.com

# Higher quality (larger files)
python3 optimize_images.py web/assets/img --jpeg-quality 90 --force

# Lower quality (smaller files)
python3 optimize_images.py web/assets/img --jpeg-quality 75 --force

# Commit changes
git add web/assets/img
git commit -m "Re-optimize images with new quality settings"
git push

# Rebuild
cd /Users/kev/Web/ClusteredPi/stacks/kevsrobots
docker-compose build --no-cache
```

## Configuration

### Environment Variables

Set in `docker-compose.yml`:

- `JEKYLL_UID`: User ID (default: 1000)
- `JEKYLL_GID`: Group ID (default: 1000)
- `JEKYLL_ENV`: Environment (production)
- `DOCKER_BUILDKIT`: Enable BuildKit (1)

### Nginx Configuration

`nginx-optimized.conf` enables:

- **Gzip compression:** text/html, css, js, xml, json
- **Caching:** 1 year for assets, 1 hour for HTML
- **MIME types:** Proper content-type headers

### Health Check

Container checks every 30s:
```bash
wget --quiet --tries=1 --spider http://localhost:3333/
```

Restarts automatically if unhealthy (3 failed checks).

## Performance

### Build Time

| Metric | Old | New | Improvement |
|--------|-----|-----|-------------|
| Base images | Ubuntu (77MB×2) | Alpine (5MB×2) | 93% smaller |
| Gem install | 2-4 min | 1 min | 60% faster |
| Jekyll build | 3-8 min | 35s | 80% faster |
| **Total** | **10-22 min** | **2 min** | **80-90% faster** |

### Runtime

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| HTML size | 94-354KB | 60-230KB | 30-50% smaller |
| Page load | 160ms | 80-100ms | 50% faster |
| Images (initial) | All | Visible only | 60-80% fewer |
| Text transfer | Raw | Gzipped | 70% less |

### Image Size

```bash
docker images kevsrobots:latest
# REPOSITORY   TAG      SIZE
# kevsrobots   latest   2.5GB
```

**Breakdown:**
- Nginx: 23MB
- Built site: ~1GB (minified HTML + optimized images)
- Layers: ~1.5GB

## Monitoring

### Check Container Status

```bash
docker-compose ps
# Should show "(healthy)" in STATUS column
```

### View Logs

```bash
docker-compose logs -f kevsrobots
```

### Test Endpoints

```bash
# Homepage
curl http://localhost:3333

# Check gzip
curl -I -H "Accept-Encoding: gzip" http://localhost:3333 | grep "Content-Encoding"
# Output: Content-Encoding: gzip

# Check minification
curl http://localhost:3333 | head -1
# Should be single line, no whitespace
```

### Performance Testing

```bash
# Response time
curl -w "\nTime: %{time_total}s\n" -o /dev/null -s http://localhost:3333

# Page size
curl -s http://localhost:3333 | wc -c
```

## Troubleshooting

### Build Fails

**"BuildKit not found"**
```bash
# Enable BuildKit
export DOCKER_BUILDKIT=1
# Or set permanently in ~/.bashrc or ~/.zshrc
```

**"nginx-optimized.conf not found"**
```bash
# Make sure you're in the right directory
pwd
# Should be: /Users/kev/Web/ClusteredPi/stacks/kevsrobots

ls nginx-optimized.conf
# Should exist
```

### Container Unhealthy

```bash
# Check logs
docker-compose logs kevsrobots

# Check nginx config
docker exec kevsrobots_kevsrobots_1 nginx -t

# Restart
docker-compose restart
```

### Slow Build

```bash
# Check if BuildKit is enabled
docker buildx version

# Clean cache and rebuild
docker system prune -a
docker-compose build --no-cache
```

### Wrong Architecture

```bash
# Check architecture
docker inspect kevsrobots:latest --format='{{.Architecture}}'
# Should output: arm64

# If wrong, rebuild on ARM64 machine
docker buildx build --platform linux/arm64 -t kevsrobots:latest .
```

## Rollback

If optimization causes issues:

### Revert to Old Dockerfile

```bash
cp dockerfile.old dockerfile
docker-compose build
docker-compose up -d
```

### Use Specific Git Tag

```bash
# In kevsrobots.com repo
cd /Users/kev/Web/kevsrobots.com
git checkout v1.0-pre-docker-optimization

# Rebuild
cd /Users/kev/Web/ClusteredPi/stacks/kevsrobots
docker-compose build --no-cache
```

## Maintenance

### Update Website Content

Content updates happen automatically:

1. **Push changes** to GitHub (kevsrobots.com repo)
2. **Rebuild** Docker image (pulls latest from GitHub)
3. **Redeploy** to cluster

```bash
# After pushing to GitHub
docker-compose build
docker-compose up -d
```

### Update Dependencies

```bash
# Update base images
docker pull alpine:latest
docker pull ruby:3.2-alpine
docker pull nginx:alpine

# Rebuild
docker-compose build --pull
```

### Clean Up

```bash
# Remove old images
docker image prune -a

# Remove build cache
docker buildx prune -a

# Clean everything
docker system prune -a --volumes
```

## Production Deployment

### On Raspberry Pi 5 Cluster

```bash
# 1. Pull code
git pull origin main

# 2. Build
docker-compose build

# 3. Deploy as stack (4 replicas)
docker stack deploy -c docker-compose.yml kevsrobots

# 4. Check status
docker stack ps kevsrobots

# 5. Scale if needed
docker service scale kevsrobots_kevsrobots=4
```

### Load Balancing

Nginx on host (0.0.0.0) routes to 4 Pi containers round-robin.

## Documentation

- **DOCKER_OPTIMIZATION.md** - Technical deep dive
- **BUILD_RESULTS.md** - Performance benchmarks
- **UPGRADE_NOTES.md** - Migration guide
- **OPTIMIZE_IMAGES.md** - Image optimization guide (in kevsrobots.com repo)

## Support

Questions or issues?
- GitHub: https://github.com/kevinmcaleer/kevsrobots.com/issues
- Email: kevinmcaleer@gmail.com

---

**Version:** 2.0 (Optimized)
**Last Updated:** 2025-10-03
**Platform:** ARM64 (Raspberry Pi 5)
