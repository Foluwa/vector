import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../models/payment_session_model.dart';

/// Reusable session header component - displays timer and total amount
class SessionHeader extends StatelessWidget {
  const SessionHeader({required this.session, super.key});

  final PaymentSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.paddingAll24,
      child: Column(
        children: [
          Text('SESSION ACTIVE', style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary, letterSpacing: 1.2)),
          const SizedBox(height: AppConstants.spacing8),
          Text(session.formattedDuration, style: AppTextStyles.h1.copyWith(fontSize: 48)),
          const SizedBox(height: AppConstants.spacing16),
          Text(session.formattedTotalAmount, style: AppTextStyles.h1.copyWith(fontSize: 56, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            '${session.paymentsCount} payment${session.paymentsCount == 1 ? '' : 's'} received',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
