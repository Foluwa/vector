import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/payments/services/session_service.dart';
import '../../features/payments/models/payment_session_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Persistent banner that shows when there's an active session
/// Allows users to quickly return to the active session
class ActiveSessionBanner extends ConsumerWidget {
  const ActiveSessionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);

    // Only show if session is active
    if (session == null || session.status != SessionStatus.active) {
      return const SizedBox.shrink();
    }

    return Material(
      color: AppColors.primary,
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Resume updates and navigate to session
          ref.read(activeSessionProvider.notifier).resumeUpdates();
          context.push('/session-active/${session.id}');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing12),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Pulsing indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const _PulsingDot(),
                ),
                const SizedBox(width: AppConstants.spacing12),
                // Session info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Active Payment Session', style: AppTextStyles.body2Medium.copyWith(color: AppColors.textPrimary)),
                      Text(
                        '${session.formattedTotalAmount} • ${session.paymentsCount} payment${session.paymentsCount == 1 ? '' : 's'}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                // Action icon
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pulsing dot animation for the active indicator
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(opacity: (1.0 - _controller.value).clamp(0.3, 1.0), child: child);
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }
}
