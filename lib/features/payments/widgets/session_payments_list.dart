import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../models/payment_session_model.dart';

/// Reusable recent payments list component
class SessionPaymentsList extends StatelessWidget {
  const SessionPaymentsList({required this.session, super.key});

  final PaymentSession session;

  @override
  Widget build(BuildContext context) {
    if (session.payments.isEmpty) {
      return Padding(
        padding: AppConstants.paddingH24,
        child: Container(
          padding: AppConstants.paddingAll32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppConstants.borderRadiusLarge,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(Icons.qr_code_scanner, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
              const SizedBox(height: AppConstants.spacing16),
              Text('No payments yet', style: AppTextStyles.body1Medium),
              const SizedBox(height: AppConstants.spacing8),
              Text(
                'Share the QR code above to start receiving payments',
                style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: AppConstants.paddingH24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Payments', style: AppTextStyles.h3),
          const SizedBox(height: AppConstants.spacing16),
          ...session.payments.take(5).map((payment) => _PaymentItem(payment: payment)),
        ],
      ),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  const _PaymentItem({required this.payment});

  final SessionPayment payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      padding: AppConstants.paddingAll16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppConstants.borderRadiusMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
            child: Center(
              child: Text(payment.initials, style: AppTextStyles.body1Medium.copyWith(color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: AppConstants.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.payerName, style: AppTextStyles.body1Medium),
                Text(payment.timeOnly, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment.formattedAmount,
                style: AppTextStyles.body1Medium.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
              ),
              Text(payment.transactionReference, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
