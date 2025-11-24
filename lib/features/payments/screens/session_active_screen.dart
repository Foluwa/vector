import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/services/notification_service.dart';
import '../models/payment_session_model.dart';
import '../services/session_service.dart';

/// Session Active Screen - Shows QR code, timer, and real-time payment updates
class SessionActiveScreen extends ConsumerStatefulWidget {
  const SessionActiveScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<SessionActiveScreen> createState() => _SessionActiveScreenState();
}

class _SessionActiveScreenState extends ConsumerState<SessionActiveScreen> {
  bool _isEndingSession = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 140), // Space for sticky bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with timer and total
                  _buildHeader(session),
                  const SizedBox(height: 24),
                  // QR code section
                  _buildQRSection(session),
                  const SizedBox(height: 32),
                  // Recent payments list
                  _buildRecentPayments(session),
                ],
              ),
            ),
            // Sticky bottom bar
            Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar(session)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PaymentSession session) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('SESSION ACTIVE', style: AppTextStyles.captionMedium.copyWith(color: AppColors.primary, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(session.formattedDuration, style: AppTextStyles.h1.copyWith(fontSize: 48)),
          const SizedBox(height: 16),
          Text(session.formattedTotalAmount, style: AppTextStyles.h1.copyWith(fontSize: 56, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            '${session.paymentsCount} payment${session.paymentsCount == 1 ? '' : 's'} received',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection(PaymentSession session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: QrImageView(data: session.qrPayload, version: QrVersions.auto, size: 280, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 16),
          // URL and action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(
                  session.publicUrl,
                  style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(session.publicUrl),
                        icon: const Icon(Icons.content_copy, size: 18),
                        label: const Text('Copy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareSession(session.publicUrl),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
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

  Widget _buildRecentPayments(PaymentSession session) {
    if (session.payments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.payment, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('Waiting for first payment...', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Payments', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          ...session.payments.reversed.map((payment) => _buildPaymentItem(payment)),
        ],
      ),
    );
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
          // Name and amount
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.payerName, style: AppTextStyles.body1Medium),
                Text(payment.formattedAmount, style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Status and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.check, size: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(payment.timeAgo, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(PaymentSession session) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _showAddNoteDialog,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      label: const Text('Add Note'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showSessionSummary(session),
                      icon: const Icon(Icons.bar_chart, size: 20),
                      label: const Text('View Summary'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),
            ),
            // End session button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isEndingSession ? null : _showEndSessionDialog,
                  icon: _isEndingSession
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.cancel_outlined, size: 20),
                  label: Text(_isEndingSession ? 'Ending session...' : 'End Session'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    NotificationService.showCopied('Session link');
  }

  void _shareSession(String url) {
    // In a real app, use share_plus package
    // For now, just show a message
    NotificationService.showInfo('Share: $url');
  }

  void _showAddNoteDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Session Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Session note (optional)', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(activeSessionProvider.notifier).addNote(controller.text);
              }
              Navigator.of(context).pop();
              NotificationService.showActionSuccess('Note added');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSessionSummary(PaymentSession session) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session Summary', style: AppTextStyles.h2),
            const SizedBox(height: 16),
            _summaryRow('Total Payments', '${session.paymentsCount}'),
            _summaryRow('Gross Amount', session.formattedTotalAmount),
            _summaryRow('Estimated Fees', session.formattedTotalFees),
            const Divider(height: 24),
            _summaryRow('Net Amount', session.formattedNetAmount, isHighlighted: true),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Close', onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isHighlighted ? AppTextStyles.body1Medium : AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
          Text(value, style: isHighlighted ? AppTextStyles.h3.copyWith(color: AppColors.primary) : AppTextStyles.body1Medium),
        ],
      ),
    );
  }

  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('No more payments will be accepted via this QR link.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _endSession();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  Future<void> _endSession() async {
    setState(() => _isEndingSession = true);

    try {
      await ref.read(activeSessionProvider.notifier).endSession();

      if (mounted) {
        context.go('/session-settlement/${widget.sessionId}');
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showError('Could not end session. Please try again.');
        setState(() => _isEndingSession = false);
      }
    }
  }
}
