import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// Skeleton loading for cards
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({this.height = 100, this.width = double.infinity, super.key});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeleton,
      highlightColor: AppColors.surface,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: AppColors.skeleton, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

/// Skeleton loading for text lines
class SkeletonText extends StatelessWidget {
  const SkeletonText({this.width = double.infinity, this.height = 16, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeleton,
      highlightColor: AppColors.surface,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: AppColors.skeleton, borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

/// Skeleton loading for circular avatars
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({this.size = 48, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeleton,
      highlightColor: AppColors.surface,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: AppColors.skeleton, shape: BoxShape.circle),
      ),
    );
  }
}

/// Loading overlay
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.overlay,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
              if (message != null) ...[const SizedBox(height: 16), Text(message!, textAlign: TextAlign.center)],
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton list for payment requests
class SkeletonPaymentList extends StatelessWidget {
  const SkeletonPaymentList({this.itemCount = 3, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const SkeletonCard(height: 80),
    );
  }
}
