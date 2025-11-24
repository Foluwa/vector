import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/notification_service.dart';
import '../services/session_service.dart';
import '../widgets/session_header.dart';
import '../widgets/session_qr_section.dart';
import '../widgets/session_payments_list.dart';
import '../widgets/session_bottom_bar.dart';

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
  void initState() {
    super.initState();
    // Ensure timer is running when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final session = ref.read(activeSessionProvider);

        // If session is null, try to restore from storage (handles hot reload)
        if (session == null) {
          ref.read(activeSessionProvider.notifier).restoreSession().then((_) {
            // After restoration, ensure timer is running
            if (mounted) {
              ref.read(activeSessionProvider.notifier).ensureTimerRunning();
            }
          });
        } else {
          // Session exists, just ensure timer is running
          ref.read(activeSessionProvider.notifier).ensureTimerRunning();
        }
      }
    });
  }

  @override
  void dispose() {
    // Pause updates but keep session active when leaving screen
    // Call pauseUpdates before dispose to avoid "ref after dispose" error
    try {
      ref.read(activeSessionProvider.notifier).pauseUpdates();
    } catch (e) {
      // Ignore errors if already disposed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && mounted) {
          // Session stays active, just pause updates
          try {
            ref.read(activeSessionProvider.notifier).pauseUpdates();
          } catch (e) {
            // Ignore if already disposed
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Pause updates before navigating away
              if (mounted) {
                ref.read(activeSessionProvider.notifier).pauseUpdates();
              }
              context.pop();
            },
          ),
          title: Text(
            'Active Session',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          actions: [
            // Optional: Add more actions like share, info, etc.
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Payment Session'),
                    content: const Text('This session will continue collecting payments until you end it. You can navigate away and return anytime.'),
                    actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Got it'))],
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 140), // Space for sticky bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with timer and total
                    SessionHeader(session: session),
                    const SizedBox(height: AppConstants.spacing24),
                    // QR code section
                    SessionQRSection(session: session),
                    const SizedBox(height: AppConstants.spacing32),
                    // Recent payments list
                    SessionPaymentsList(session: session),
                  ],
                ),
              ),
              // Sticky bottom bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SessionBottomBar(session: session, isEnding: _isEndingSession, onEndSession: _handleEndSession),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEndSession() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('Are you sure you want to end this payment session? You can still review the details afterward.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('End Session'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isEndingSession = true);

    try {
      final session = ref.read(activeSessionProvider);
      if (session != null) {
        await ref.read(activeSessionProvider.notifier).endSession();

        if (mounted) {
          NotificationService.showSuccess('Session ended successfully');
          context.go('/session-settlement/${session.id}');
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showError('Failed to end session');
        setState(() => _isEndingSession = false);
      }
    }
  }
}
