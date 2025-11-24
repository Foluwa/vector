import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../utils/image_loader.dart';

/// User avatar with initials or network image
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.initials, this.name, this.imageUrl, this.size = 48, this.backgroundColor, this.textColor, this.showName = false, super.key});

  final String initials;
  final String? name;
  final String? imageUrl; // Network image URL
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show network image if available, otherwise show initials
        imageUrl != null && imageUrl!.isNotEmpty
            ? ImageLoader.loadAvatarImage(
                imageUrl: imageUrl!,
                size: size,
                placeholder: _buildInitialsAvatar(), // Fallback to initials while loading
                errorWidget: _buildInitialsAvatar(), // Fallback to initials on error
              )
            : _buildInitialsAvatar(),
        if (showName && name != null) ...[
          const SizedBox(height: AppConstants.spacing4),
          SizedBox(
            width: size + 20,
            child: Text(
              name!,
              style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor ?? AppColors.primary, shape: BoxShape.circle),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.body1Medium.copyWith(color: textColor ?? AppColors.textPrimary, fontSize: size * 0.4),
        ),
      ),
    );
  }
}

/// Recent recipient chip
class RecipientChip extends StatelessWidget {
  const RecipientChip({required this.initials, required this.name, required this.onTap, this.imageUrl, super.key});

  final String initials;
  final String name;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppConstants.borderRadiusMedium,
      child: Padding(
        padding: AppConstants.paddingAll8,
        child: UserAvatar(initials: initials, name: name, imageUrl: imageUrl, size: 56, showName: true),
      ),
    );
  }
}
