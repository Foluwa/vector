import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../models/payment_session_model.dart';

/// Reusable sticky bottom bar component for session actions
class SessionBottomBar extends StatelessWidget {
  const SessionBottomBar({required this.session, required this.isEnding, required this.onEndSession, super.key});

  final PaymentSession session;
  final bool isEnding;
  final VoidCallback onEndSession;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.paddingAll24,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Session info summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Collected', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Text(session.formattedTotalAmount, style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Duration', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Text(session.formattedDuration, style: AppTextStyles.body1Medium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacing16),
            // End session button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEnding ? null : onEndSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: AppConstants.borderRadiusLarge),
                ),
                child: Text(isEnding ? 'Ending Session...' : 'End Session', style: AppTextStyles.body1Medium.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
