#!/usr/bin/env python3
"""
Image Optimization Script for KevsRobots Website
Optimizes images for web delivery while maintaining quality
"""

import os
import sys
from pathlib import Path
from PIL import Image
import argparse

class ImageOptimizer:
    def __init__(self, source_dir, output_dir, max_width=1920, max_height=1920,
                 jpeg_quality=85, webp_quality=85, convert_to_webp=True):
        self.source_dir = Path(source_dir)
        self.output_dir = Path(output_dir)
        self.max_width = max_width
        self.max_height = max_height
        self.jpeg_quality = jpeg_quality
        self.webp_quality = webp_quality
        self.convert_to_webp = convert_to_webp

        self.stats = {
            'processed': 0,
            'skipped': 0,
            'original_size': 0,
            'optimized_size': 0,
            'errors': []
        }

    def optimize_image(self, image_path, output_path):
        """Optimize a single image file"""
        try:
            original_size = image_path.stat().st_size

            # Open and process image
            with Image.open(image_path) as img:
                # Convert RGBA to RGB for JPEG/WebP
                if img.mode in ('RGBA', 'LA', 'P'):
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    if img.mode == 'P':
                        img = img.convert('RGBA')
                    background.paste(img, mask=img.split()[-1] if img.mode in ('RGBA', 'LA') else None)
                    img = background
                elif img.mode != 'RGB':
                    img = img.convert('RGB')

                # Resize if needed
                if img.width > self.max_width or img.height > self.max_height:
                    img.thumbnail((self.max_width, self.max_height), Image.Resampling.LANCZOS)

                # Determine output format and quality
                if self.convert_to_webp:
                    output_path = output_path.with_suffix('.webp')
                    img.save(output_path, 'WEBP', quality=self.webp_quality, method=6)
                elif image_path.suffix.lower() in ['.jpg', '.jpeg']:
                    img.save(output_path, 'JPEG', quality=self.jpeg_quality, optimize=True)
                elif image_path.suffix.lower() == '.png':
                    img.save(output_path, 'PNG', optimize=True)
                else:
                    # Copy other formats as-is
                    img.save(output_path)

            optimized_size = output_path.stat().st_size
            self.stats['original_size'] += original_size
            self.stats['optimized_size'] += optimized_size
            self.stats['processed'] += 1

            reduction = ((original_size - optimized_size) / original_size * 100) if original_size > 0 else 0
            print(f"✓ {image_path.name} → {output_path.name} ({self._format_size(original_size)} → {self._format_size(optimized_size)}, {reduction:.1f}% reduction)")

        except Exception as e:
            self.stats['errors'].append(f"{image_path}: {str(e)}")
            self.stats['skipped'] += 1
            print(f"✗ Error processing {image_path.name}: {str(e)}")

    def _format_size(self, size_bytes):
        """Format bytes to human-readable size"""
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size_bytes < 1024.0:
                return f"{size_bytes:.1f}{unit}"
            size_bytes /= 1024.0
        return f"{size_bytes:.1f}TB"

    def process_directory(self):
        """Process all images in source directory"""
        if not self.source_dir.exists():
            print(f"Error: Source directory {self.source_dir} does not exist")
            sys.exit(1)

        # Create output directory structure
        self.output_dir.mkdir(parents=True, exist_ok=True)

        # Supported image formats
        image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.webp'}

        # Walk through directory tree
        for root, dirs, files in os.walk(self.source_dir):
            rel_path = Path(root).relative_to(self.source_dir)
            output_root = self.output_dir / rel_path
            output_root.mkdir(parents=True, exist_ok=True)

            for file in files:
                file_path = Path(root) / file

                if file_path.suffix.lower() in image_extensions:
                    output_path = output_root / file
                    self.optimize_image(file_path, output_path)
                else:
                    # Copy non-image files as-is
                    output_file = output_root / file
                    try:
                        output_file.write_bytes(file_path.read_bytes())
                    except Exception as e:
                        print(f"✗ Error copying {file}: {str(e)}")

    def print_summary(self):
        """Print optimization summary"""
        print("\n" + "="*60)
        print("OPTIMIZATION SUMMARY")
        print("="*60)
        print(f"Images processed: {self.stats['processed']}")
        print(f"Images skipped: {self.stats['skipped']}")
        print(f"Original size: {self._format_size(self.stats['original_size'])}")
        print(f"Optimized size: {self._format_size(self.stats['optimized_size'])}")

        if self.stats['original_size'] > 0:
            total_reduction = ((self.stats['original_size'] - self.stats['optimized_size']) /
                             self.stats['original_size'] * 100)
            print(f"Total reduction: {total_reduction:.1f}%")

        if self.stats['errors']:
            print(f"\nErrors encountered: {len(self.stats['errors'])}")
            for error in self.stats['errors'][:10]:  # Show first 10 errors
                print(f"  - {error}")


def main():
    parser = argparse.ArgumentParser(
        description='Optimize images for web delivery',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument('source', help='Source directory containing images')
    parser.add_argument('output', help='Output directory for optimized images')
    parser.add_argument('--max-width', type=int, default=1920, help='Maximum image width')
    parser.add_argument('--max-height', type=int, default=1920, help='Maximum image height')
    parser.add_argument('--jpeg-quality', type=int, default=85, help='JPEG quality (1-100)')
    parser.add_argument('--webp-quality', type=int, default=85, help='WebP quality (1-100)')
    parser.add_argument('--no-webp', action='store_true', help='Do not convert to WebP format')

    args = parser.parse_args()

    optimizer = ImageOptimizer(
        source_dir=args.source,
        output_dir=args.output,
        max_width=args.max_width,
        max_height=args.max_height,
        jpeg_quality=args.jpeg_quality,
        webp_quality=args.webp_quality,
        convert_to_webp=not args.no_webp
    )

    print(f"Starting image optimization...")
    print(f"Source: {args.source}")
    print(f"Output: {args.output}")
    print(f"Max dimensions: {args.max_width}x{args.max_height}")
    print(f"JPEG quality: {args.jpeg_quality}")
    print(f"WebP quality: {args.webp_quality}")
    print(f"Convert to WebP: {not args.no_webp}")
    print("="*60 + "\n")

    optimizer.process_directory()
    optimizer.print_summary()


if __name__ == '__main__':
    main()
