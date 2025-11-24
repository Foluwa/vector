import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';

/// Utility class for optimized image loading with caching and lazy loading
class ImageLoader {
  /// Load network image with caching, lazy loading, and error handling
  static Widget loadNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    bool useMemCacheOnly = false,
  }) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: width != null ? (width * 2).toInt() : null, // 2x for better quality on retina displays
      memCacheHeight: height != null ? (height * 2).toInt() : null,
      maxWidthDiskCache: 1000, // Limit disk cache size
      maxHeightDiskCache: 1000,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            color: AppColors.surface,
            child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            color: AppColors.surface,
            child: Icon(Icons.error_outline, color: AppColors.textSecondary, size: 32),
          ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    }

    return image;
  }

  /// Load circular avatar image with caching
  static Widget loadAvatarImage({required String imageUrl, required double size, Widget? placeholder, Widget? errorWidget}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      memCacheWidth: (size * 2).toInt(),
      memCacheHeight: (size * 2).toInt(),
      maxWidthDiskCache: 500,
      maxHeightDiskCache: 500,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: Center(
              child: SizedBox(width: size * 0.4, height: size * 0.4, child: const CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: Icon(Icons.person_outline, color: AppColors.textSecondary, size: size * 0.5),
          ),
    );
  }

  /// Precache network image for faster loading later
  static Future<void> precacheNetworkImage(BuildContext context, String imageUrl) async {
    try {
      await precacheImage(CachedNetworkImageProvider(imageUrl), context);
    } catch (e) {
      // Silently fail - image will be loaded when needed
      debugPrint('Failed to precache image: $imageUrl');
    }
  }

  /// Precache multiple images
  static Future<void> precacheMultipleImages(BuildContext context, List<String> imageUrls) async {
    await Future.wait(imageUrls.map((url) => precacheNetworkImage(context, url)));
  }
}
