import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/services/notification_service.dart';
import '../models/payment_session_model.dart';
import '../services/session_service.dart';

/// Session Settlement Screen - Shows final payment breakdown and settlement details
class SessionSettlementScreen extends ConsumerWidget {
  const SessionSettlementScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);
    final sessionService = ref.watch(sessionServiceProvider);

    // If session not in active provider, fetch it
    final displaySession = session?.id == sessionId ? session : sessionService.getSession(sessionId);

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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Payments list
            _buildPaymentsList(displaySession),
            const SizedBox(height: 32),
            // Settlement section
            _buildSettlementSection(displaySession),
            const SizedBox(height: 24),
            // Action buttons
            _buildActionButtons(context, displaySession),
            const SizedBox(height: 16),
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

  Widget _buildPaymentsList(PaymentSession session) {
    if (session.payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24)),
            child: Center(
              child: Text(payment.initials, style: AppTextStyles.body1Medium.copyWith(color: AppColors.textPrimary)),
            ),
          ),
          const SizedBox(width: 12),
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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settlement Details', style: AppTextStyles.body1Medium),
              const SizedBox(height: 16),
              _buildSettlementRow('Total Fees', session.formattedTotalFees),
              const Divider(height: 32),
              _buildSettlementRow('Net Amount Settled', session.formattedNetAmount, isHighlighted: true),
              const Divider(height: 32),
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
          icon: const Icon(Icons.share, size: 20),
          label: const Text('Share Summary'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),
        // Export to CSV
        OutlinedButton.icon(
          onPressed: () => _exportToCSV(context, session),
          icon: const Icon(Icons.download, size: 20),
          label: const Text('Export to CSV'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),
        // View in History
        TextButton.icon(
          onPressed: () => context.go('/history'),
          icon: const Icon(Icons.access_time, size: 20),
          label: const Text('View in History'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  void _shareSessionSummary(BuildContext context, PaymentSession session) {
    // In a real app, use share_plus package to share session data
    NotificationService.showInfo('Sharing session summary...');
  }

  void _exportToCSV(BuildContext context, PaymentSession session) {
    // In a real app, generate and download CSV
    NotificationService.showInfo('CSV export functionality - coming soon');
  }
}
