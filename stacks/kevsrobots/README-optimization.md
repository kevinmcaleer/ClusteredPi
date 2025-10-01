# Image Optimization Setup

This directory contains image optimization tools for the KevsRobots website.

## Files Created

1. **optimize_images.py** - Python script that optimizes images
2. **dockerfile-optimized** - Enhanced Dockerfile with image optimization stage
3. **nginx-optimized.conf** - Nginx config with caching and compression

## How It Works

The optimization process runs in the Docker build:

```
Stage 1: Clone repository from GitHub
Stage 2: Optimize images (resize, convert to WebP)
Stage 3: Build Jekyll site with optimized images
Stage 4: Serve with Nginx (gzip + caching enabled)
```

## Usage

### Option 1: Use the optimized Dockerfile

```bash
cd /Users/kev/Web/ClusteredPi/stacks/kevsrobots
docker build -f dockerfile-optimized -t kevsrobots:optimized .
```

### Option 2: Run the optimization script locally

```bash
# Install Pillow
pip install Pillow

# Run optimization
python3 optimize_images.py \
    /Users/kev/Web/kevsrobots.com/web/assets/img \
    /tmp/optimized-images \
    --max-width 1920 \
    --max-height 1920 \
    --jpeg-quality 85 \
    --webp-quality 85
```

## Customization Options

Edit the optimization parameters in `dockerfile-optimized` (lines 28-34):

```dockerfile
RUN python3 /opt/optimize_images.py \
    /src/images-original \
    /src/images-optimized \
    --max-width 1920 \        # Max width in pixels
    --max-height 1920 \       # Max height in pixels
    --jpeg-quality 85 \       # JPEG quality (1-100)
    --webp-quality 85         # WebP quality (1-100)
    # Add --no-webp to keep original formats
```

### Quality vs Size Tradeoffs

| Setting | File Size | Quality | Use Case |
|---------|-----------|---------|----------|
| `--webp-quality 95` | Larger | Excellent | Photography/hero images |
| `--webp-quality 85` | Medium | Very good | **Recommended default** |
| `--webp-quality 75` | Smaller | Good | Blog posts/thumbnails |
| `--webp-quality 60` | Smallest | Acceptable | Backgrounds/decorative |

### Resolution Settings

Current images are often 4032x3024 (12MP camera resolution):
- `--max-width 1920`: Full HD displays (recommended)
- `--max-width 2560`: 2K displays (larger files)
- `--max-width 1280`: Smaller, faster loading

## Expected Results

Based on current stats (1.1GB images, 1,501 files):

- **Original size**: 1.1GB
- **Optimized size**: ~150-250MB (75-85% reduction)
- **Format**: WebP (better compression than JPEG)
- **Quality**: Visually identical at 85% quality
- **Build time**: +2-3 minutes for optimization stage

## Performance Gains

With optimized images + nginx caching:

- **First visit**: 60-80% faster page loads
- **Return visits**: 90% faster (cached assets)
- **Bandwidth**: 75-85% reduction
- **Mobile**: Significantly faster on 4G/5G

## Rollback

To revert to original images, use the original `dockerfile`:

```bash
docker build -f dockerfile -t kevsrobots:latest .
```

## Browser Compatibility

WebP is supported by all modern browsers:
- Chrome/Edge: ✓
- Firefox: ✓
- Safari: ✓ (since v14, 2020)
- Mobile browsers: ✓

For older browsers, you can disable WebP conversion with `--no-webp` flag.

## Monitoring

After deployment, compare:

```bash
# Check image sizes in built site
docker run --rm kevsrobots:optimized du -sh /www/data/assets/img

# Compare with original
docker run --rm kevsrobots:latest du -sh /www/data/assets/img
```

## Next Steps

1. Test the optimized build locally
2. Compare visual quality on sample pages
3. Adjust quality settings if needed
4. Deploy to production
5. Monitor performance improvements with browser DevTools

## Notes

- Original images remain unchanged in the source repository
- Optimization happens only during Docker build
- To improve quality later, just adjust parameters and rebuild
- No need to modify source images in the repository
