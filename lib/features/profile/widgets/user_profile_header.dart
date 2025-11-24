import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/avatars.dart';
import '../../auth/services/auth_service.dart';

/// Reusable user profile header component
class UserProfileHeader extends ConsumerWidget {
  const UserProfileHeader({required this.onEditPressed, super.key});

  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);

    return Column(
      children: [
        UserAvatar(initials: user?.initials ?? 'U', imageUrl: user?.avatarUrl, size: 80),
        const SizedBox(height: AppConstants.spacing16),
        Text(user?.displayName ?? 'User', style: AppTextStyles.h2),
        Text(user?.email ?? 'user@example.com', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppConstants.spacing16),
        SecondaryButton(label: 'Edit Profile', onPressed: onEditPressed, fullWidth: false),
      ],
    );
  }
}
