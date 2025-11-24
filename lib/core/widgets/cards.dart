import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Action card for primary actions (e.g., "Receive Payment", "Scan to Pay")
class ActionCard extends StatelessWidget {
  const ActionCard({required this.title, required this.subtitle, required this.onTap, this.icon, this.isPrimary = false, super.key});

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppConstants.borderRadiusLarge,
      child: Container(
        padding: AppConstants.paddingAll20,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.background,
          borderRadius: AppConstants.borderRadiusLarge,
          border: Border.all(color: isPrimary ? AppColors.primary : AppColors.border, width: AppConstants.borderThin),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppConstants.iconLarge, color: isPrimary ? AppColors.textPrimary : AppColors.primary),
              const SizedBox(width: AppConstants.spacing16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body1Medium.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: AppConstants.spacing4),
                  Text(subtitle, style: AppTextStyles.body2.copyWith(color: isPrimary ? AppColors.textPrimary : AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info card with border
class InfoCard extends StatelessWidget {
  const InfoCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppConstants.paddingAll20,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppConstants.borderRadiusLarge,
        border: Border.all(color: AppColors.border, width: AppConstants.borderThin),
      ),
      child: child,
    );
  }
}

/// Bank account card
class BankAccountCard extends StatelessWidget {
  const BankAccountCard({
    required this.bankName,
    required this.accountType,
    required this.maskedNumber,
    this.isDefault = false,
    this.isExpired = false,
    this.onTap,
    this.onMenuTap,
    this.onReconnect,
    super.key,
  });

  final String bankName;
  final String accountType;
  final String maskedNumber;
  final bool isDefault;
  final bool isExpired;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onReconnect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppConstants.borderRadiusLarge,
      child: Container(
        padding: AppConstants.paddingAll16,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppConstants.borderRadiusLarge,
          border: Border.all(color: AppColors.border, width: AppConstants.borderThin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: AppConstants.paddingAll12,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusSmall),
                  child: const Icon(Icons.credit_card, size: AppConstants.iconMedium, color: AppColors.textSecondary),
                ),
                const SizedBox(width: AppConstants.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bankName, style: AppTextStyles.body1Medium),
                      Text(accountType, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (onMenuTap != null) IconButton(icon: const Icon(Icons.more_vert), color: AppColors.textSecondary, onPressed: onMenuTap),
              ],
            ),
            const SizedBox(height: AppConstants.spacing12),
            Text(maskedNumber, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
            if (isDefault || isExpired) ...[
              const SizedBox(height: AppConstants.spacing12),
              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppConstants.borderRadiusMedium),
                  child: Text('DEFAULT', style: AppTextStyles.captionMedium.copyWith(color: AppColors.textPrimary)),
                ),
              if (isExpired) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: AppConstants.borderRadiusMedium),
                  child: Text('Connection expired', style: AppTextStyles.captionMedium.copyWith(color: AppColors.warning)),
                ),
                const SizedBox(height: AppConstants.spacing12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onReconnect,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      side: const BorderSide(color: AppColors.warning, width: 1.5),
                    ),
                    child: Text('Reconnect', style: AppTextStyles.buttonSmall.copyWith(color: AppColors.warning)),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
