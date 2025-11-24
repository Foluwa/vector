import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/cards.dart';

/// Reusable Vector Pro promotion card component
class VectorProCard extends StatelessWidget {
  const VectorProCard({required this.onUpgradePressed, super.key});

  final VoidCallback onUpgradePressed;

  static const List<String> features = [
    'Priority transaction processing',
    'Advanced analytics dashboard',
    'Custom QR code branding',
    'API access for integrations',
    'Dedicated support channel',
  ];

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.primary, size: AppConstants.iconLarge),
              const SizedBox(width: AppConstants.spacing8),
              Text('Vector Pro', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text('Unlock advanced features for power users', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppConstants.spacing16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacing8),
              child: Row(
                children: [
                  const Icon(Icons.check, size: AppConstants.iconSmall, color: AppColors.primary),
                  const SizedBox(width: AppConstants.spacing8),
                  Expanded(child: Text(feature, style: AppTextStyles.body2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          PrimaryButton(label: 'Go Pro — \u00A39/month', onPressed: onUpgradePressed),
        ],
      ),
    );
  }
}
