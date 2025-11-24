import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// User avatar with initials
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.initials, this.name, this.size = 48, this.backgroundColor, this.textColor, this.showName = false, super.key});

  final String initials;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: backgroundColor ?? AppColors.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(
              initials,
              style: AppTextStyles.body1Medium.copyWith(color: textColor ?? AppColors.textPrimary, fontSize: size * 0.4),
            ),
          ),
        ),
        if (showName && name != null) ...[
          const SizedBox(height: 4),
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
}

/// Recent recipient chip
class RecipientChip extends StatelessWidget {
  const RecipientChip({required this.initials, required this.name, required this.onTap, super.key});

  final String initials;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: UserAvatar(initials: initials, name: name, size: 56, showName: true),
      ),
    );
  }
}
