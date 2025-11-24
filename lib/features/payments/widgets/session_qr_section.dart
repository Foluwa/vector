import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/share_service.dart';
import '../models/payment_session_model.dart';

/// Reusable QR code section component - displays QR code with share/copy actions
class SessionQRSection extends StatelessWidget {
  SessionQRSection({required this.session, super.key});

  final PaymentSession session;
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.paddingH24,
      child: Column(
        children: [
          Container(
            padding: AppConstants.paddingAll24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppConstants.borderRadiusLarge,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text('Scan to Pay', style: AppTextStyles.h3),
                const SizedBox(height: AppConstants.spacing16),
                RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    padding: AppConstants.paddingAll16,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: AppConstants.borderRadiusMedium),
                    child: QrImageView(data: session.publicUrl, version: QrVersions.auto, size: 200),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing16),
                Text('Payment Link', style: AppTextStyles.captionMedium),
                const SizedBox(height: AppConstants.spacing8),
                Container(
                  padding: AppConstants.paddingH16V12,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          session.publicUrl,
                          style: AppTextStyles.caption.copyWith(fontFamily: 'monospace', color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacing8),
                      InkWell(
                        onTap: () => _copyLink(session.publicUrl),
                        child: const Icon(Icons.copy, size: AppConstants.iconSmall, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacing16),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(label: 'Share Link', onPressed: () => _shareLink(session)),
                    ),
                    const SizedBox(width: AppConstants.spacing12),
                    Expanded(
                      child: SecondaryButton(label: 'Share QR', onPressed: () => _shareQR(context, session)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link));
    NotificationService.showSuccess('Payment link copied!');
  }

  Future<void> _shareLink(PaymentSession session) async {
    try {
      // Share link without QR image
      await ShareService.shareSessionUrl(session.publicUrl, session.id);
    } catch (e) {
      NotificationService.showError('Failed to share link');
    }
  }

  Future<void> _shareQR(BuildContext context, PaymentSession session) async {
    try {
      // Share with QR code image
      await ShareService.shareSessionUrl(session.publicUrl, session.id, qrKey: _qrKey);
    } catch (e) {
      NotificationService.showError('Failed to share QR code');
    }
  }
}
