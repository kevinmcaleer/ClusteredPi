#!/bin/bash
# Compare old vs new Docker build

set -e

echo "======================================"
echo "Docker Build Comparison Tool"
echo "======================================"
echo ""

# Check BuildKit
if [ -z "$DOCKER_BUILDKIT" ]; then
    echo "⚠️  BuildKit not enabled. Run: export DOCKER_BUILDKIT=1"
    echo ""
fi

# Build old version
echo "📦 Building OLD Dockerfile..."
echo "------------------------------"
time_old_start=$(date +%s)
docker build --no-cache -f dockerfile -t kevsrobots:old . > /tmp/build_old.log 2>&1
time_old_end=$(date +%s)
time_old=$((time_old_end - time_old_start))

# Build new version
echo ""
echo "⚡ Building NEW Dockerfile (fast)..."
echo "------------------------------"
time_new_start=$(date +%s)
DOCKER_BUILDKIT=1 docker build --no-cache -f dockerfile-fast -t kevsrobots:new . > /tmp/build_new.log 2>&1
time_new_end=$(date +%s)
time_new=$((time_new_end - time_new_start))

# Get image sizes
size_old=$(docker images kevsrobots:old --format "{{.Size}}")
size_new=$(docker images kevsrobots:new --format "{{.Size}}")

# Calculate improvements
time_saved=$((time_old - time_new))
time_percent=$((100 * time_saved / time_old))

echo ""
echo "======================================"
echo "RESULTS"
echo "======================================"
echo ""
printf "%-20s %-15s %-15s %-15s\n" "Metric" "Old" "New" "Improvement"
echo "----------------------------------------------------------------------"
printf "%-20s %-15s %-15s %-15s\n" "Build time" "${time_old}s" "${time_new}s" "-${time_saved}s (${time_percent}%)"
printf "%-20s %-15s %-15s\n" "Image size" "$size_old" "$size_new"
echo ""

# Test both containers
echo "🧪 Testing containers..."
echo "------------------------------"

# Start old
docker run -d --rm -p 3334:3333 --name test-old kevsrobots:old > /dev/null
sleep 2

# Test old
response_old=$(curl -s -w "%{time_total}" -o /dev/null http://localhost:3334)
gzip_old=$(curl -s -I -H "Accept-Encoding: gzip" http://localhost:3334 | grep -i "content-encoding" || echo "No gzip")

docker stop test-old > /dev/null

# Start new
docker run -d --rm -p 3335:3333 --name test-new kevsrobots:new > /dev/null
sleep 2

# Test new
response_new=$(curl -s -w "%{time_total}" -o /dev/null http://localhost:3335)
gzip_new=$(curl -s -I -H "Accept-Encoding: gzip" http://localhost:3335 | grep -i "content-encoding" || echo "No gzip")

docker stop test-new > /dev/null

echo ""
printf "%-20s %-15s %-15s\n" "Response time" "${response_old}s" "${response_new}s"
printf "%-20s %-15s %-15s\n" "Gzip enabled" "$gzip_old" "$gzip_new"
echo ""

echo "✅ Comparison complete!"
echo ""
echo "Logs saved to:"
echo "  - /tmp/build_old.log"
echo "  - /tmp/build_new.log"
echo ""

# Cleanup
echo "🧹 Cleanup? (y/n)"
read -r cleanup
if [ "$cleanup" = "y" ]; then
    docker rmi kevsrobots:old kevsrobots:new
    echo "✅ Cleaned up test images"
fi
