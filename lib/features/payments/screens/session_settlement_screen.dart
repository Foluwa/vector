import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/share_service.dart';
import '../models/payment_session_model.dart';
import '../services/session_service.dart';

/// Session Settlement Screen - Shows final payment breakdown and settlement details
class SessionSettlementScreen extends ConsumerStatefulWidget {
  const SessionSettlementScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<SessionSettlementScreen> createState() => _SessionSettlementScreenState();
}

class _SessionSettlementScreenState extends ConsumerState<SessionSettlementScreen> {
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);
    final sessionService = ref.watch(sessionServiceProvider);

    // If session not in active provider, fetch it
    final displaySession = session?.id == widget.sessionId ? session : sessionService.getSession(widget.sessionId);

    if (displaySession == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session Summary')),
        body: const Center(child: Text('Session not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Session Summary'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go('/history')),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // QR code section (for sharing with image)
            _buildQRSection(displaySession),
            const SizedBox(height: AppConstants.spacing24),
            // Payments list
            _buildPaymentsList(displaySession),
            const SizedBox(height: AppConstants.spacing32),
            // Settlement section
            _buildSettlementSection(displaySession),
            const SizedBox(height: AppConstants.spacing24),
            // Action buttons
            _buildActionButtons(context, displaySession),
            const SizedBox(height: AppConstants.spacing16),
            // Done button
            PrimaryButton(
              label: 'Done',
              onPressed: () {
                ref.read(activeSessionProvider.notifier).clearSession();
                context.go('/history');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRSection(PaymentSession session) {
    return Container(
      padding: AppConstants.paddingAll24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppConstants.borderRadiusLarge,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text('Payment QR Code', style: AppTextStyles.h3),
          const SizedBox(height: AppConstants.spacing16),
          RepaintBoundary(
            key: _qrKey,
            child: Container(
              padding: AppConstants.paddingAll16,
              decoration: BoxDecoration(color: Colors.white, borderRadius: AppConstants.borderRadiusMedium),
              child: QrImageView(data: session.publicUrl, version: QrVersions.auto, size: 180),
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            session.publicUrl,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList(PaymentSession session) {
    if (session.payments.isEmpty) {
      return Container(
        padding: AppConstants.paddingAll32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppConstants.borderRadiusLarge,
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text('No payments received', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
        ),
      );
    }

    return Column(children: session.payments.map((payment) => _buildPaymentItem(payment)).toList());
  }

  Widget _buildPaymentItem(SessionPayment payment) {
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
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
            child: Center(
              child: Text(payment.initials, style: AppTextStyles.body1Medium.copyWith(color: AppColors.textPrimary)),
            ),
          ),
          const SizedBox(width: AppConstants.spacing12),
          // Name and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.payerName, style: AppTextStyles.body1Medium),
                Text(payment.timeOnly, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          // Amount and transaction reference
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(payment.formattedAmount, style: AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.bold)),
              Text(payment.transactionReference, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementSection(PaymentSession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settlement', style: AppTextStyles.h2),
        const SizedBox(height: AppConstants.spacing16),
        Container(
          padding: AppConstants.paddingAll20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppConstants.borderRadiusLarge,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settlement Details', style: AppTextStyles.body1Medium),
              const SizedBox(height: AppConstants.spacing16),
              _buildSettlementRow('Total Fees', session.formattedTotalFees),
              const Divider(height: AppConstants.spacing32),
              _buildSettlementRow('Net Amount Settled', session.formattedNetAmount, isHighlighted: true),
              const Divider(height: AppConstants.spacing32),
              _buildSettlementRow('Settled To', 'Barclays ••••4892', showTrailingText: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementRow(String label, String value, {bool isHighlighted = false, bool showTrailingText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            color: isHighlighted ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body1Medium.copyWith(
            color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            fontSize: isHighlighted ? 18 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, PaymentSession session) {
    return Column(
      children: [
        // Share Summary
        OutlinedButton.icon(
          onPressed: () => _shareSessionSummary(context, session),
          icon: const Icon(Icons.share, size: AppConstants.iconMedium),
          label: const Text('Share Summary'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            padding: AppConstants.paddingV16,
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: AppConstants.spacing12),
        // Export to CSV
        OutlinedButton.icon(
          onPressed: () => _exportToCSV(context, session),
          icon: const Icon(Icons.download, size: AppConstants.iconMedium),
          label: const Text('Export to CSV'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            padding: AppConstants.paddingV16,
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: AppConstants.spacing12),
        // View in History
        TextButton.icon(
          onPressed: () => context.go('/history'),
          icon: const Icon(Icons.access_time, size: AppConstants.iconMedium),
          label: const Text('View in History'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: AppConstants.paddingV16, minimumSize: const Size(double.infinity, 48)),
        ),
      ],
    );
  }

  void _shareSessionSummary(BuildContext context, PaymentSession session) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppConstants.paddingAll24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Share Session Summary', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacing8),
            Text('Choose export format', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppConstants.spacing24),
            // Share as Text
            ListTile(
              leading: const Icon(Icons.text_fields, color: AppColors.primary),
              title: const Text('Share as Text'),
              subtitle: const Text('Simple text summary'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await ShareService.shareSessionSummary(session, qrKey: _qrKey);
                } catch (e) {
                  NotificationService.showError('Failed to share summary');
                }
              },
            ),
            // Share as PDF
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppColors.error),
              title: const Text('Export as PDF'),
              subtitle: const Text('Professional report format'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  NotificationService.showLoading('Generating PDF...');
                  await ShareService.exportSessionToPDF(session, qrKey: _qrKey);
                  NotificationService.hideAll();
                  NotificationService.showSuccess('PDF exported successfully');
                } catch (e) {
                  NotificationService.hideAll();
                  NotificationService.showError('Failed to generate PDF');
                }
              },
            ),
            const SizedBox(height: AppConstants.spacing8),
          ],
        ),
      ),
    );
  }

  void _exportToCSV(BuildContext context, PaymentSession session) async {
    try {
      NotificationService.showLoading('Generating CSV...');
      await ShareService.exportSessionToCSV(session);
      NotificationService.hideAll();
      NotificationService.showSuccess('CSV exported successfully');
    } catch (e) {
      NotificationService.hideAll();
      NotificationService.showError('Failed to export CSV');
    }
  }
}
