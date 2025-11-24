import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Production-grade notification service for Vector
/// Handles all toast/snackbar notifications with consistent styling
///
/// Usage Examples:
/// ```dart
/// NotificationService.showSuccess('Payment sent successfully!');
/// NotificationService.showError('Payment failed');
/// NotificationService.showSessionActive('Session started', sessionId: 'SES-001');
/// NotificationService.showCopied('Link copied to clipboard');
/// ```

enum NotificationType { success, error, warning, info, primary }

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static ScaffoldMessengerState? get _messenger => messengerKey.currentState;

  /// Core method to show notifications with full customization
  static void _show({
    required String message,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseButton = false,
  }) {
    final messenger = _messenger;
    if (messenger == null) {
      debugPrint('⚠️ NotificationService: ScaffoldMessenger not initialized');
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: foregroundColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: foregroundColor, size: 20),
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(color: foregroundColor, fontWeight: FontWeight.w500),
              ),
            ),
            // Close button
            if (showCloseButton)
              IconButton(
                icon: Icon(Icons.close, color: foregroundColor, size: 18),
                onPressed: () => hideAll(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        action: actionLabel != null ? SnackBarAction(label: actionLabel, textColor: foregroundColor, onPressed: onActionPressed ?? () {}) : null,
      ),
    );
  }

  // ========== Basic Notification Types ==========

  /// Show success notification (green)
  static void showSuccess(String message, {String? actionLabel, VoidCallback? onActionPressed, Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.textPrimary,
      icon: Icons.check_circle_rounded,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show error notification (red)
  static void showError(String message, {String? actionLabel, VoidCallback? onActionPressed, Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.error,
      foregroundColor: Colors.white,
      icon: Icons.error_rounded,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration ?? const Duration(seconds: 4),
      showCloseButton: true,
    );
  }

  /// Show warning notification (orange/yellow)
  static void showWarning(String message, {String? actionLabel, VoidCallback? onActionPressed, Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.warning,
      foregroundColor: Colors.black87,
      icon: Icons.warning_rounded,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show info notification (blue)
  static void showInfo(String message, {String? actionLabel, VoidCallback? onActionPressed, Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.info,
      foregroundColor: Colors.white,
      icon: Icons.info_rounded,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Show primary notification (Vector green)
  static void showPrimary(String message, {String? actionLabel, VoidCallback? onActionPressed, Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textPrimary,
      icon: Icons.bolt_rounded,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  // ========== Special Loading State ==========

  /// Show loading notification (persistent until dismissed)
  static void showLoading(String message) {
    final messenger = _messenger;
    if (messenger == null) {
      debugPrint('⚠️ NotificationService: ScaffoldMessenger not initialized');
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary))),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 30), // Long duration
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  /// Hide all active notifications
  static void hideAll() {
    _messenger?.hideCurrentSnackBar();
  }

  // ========== Vector-Specific Notifications ==========

  /// Payment sent successfully
  static void showPaymentSent({required String amount, required String recipient}) {
    showSuccess('Sent $amount to $recipient', duration: const Duration(seconds: 4));
  }

  /// Payment received
  static void showPaymentReceived({required String amount, required String sender}) {
    showSuccess('Received $amount from $sender', duration: const Duration(seconds: 4));
  }

  /// Session started
  static void showSessionActive({String? message, String? sessionId}) {
    showPrimary(message ?? 'Payment session is now active', duration: const Duration(seconds: 3));
  }

  /// Session ended
  static void showSessionEnded({required String totalAmount, required int paymentCount}) {
    showSuccess('Session ended: $totalAmount from $paymentCount payment${paymentCount == 1 ? '' : 's'}', duration: const Duration(seconds: 4));
  }

  /// Link copied to clipboard
  static void showCopied([String? item]) {
    showSuccess(item != null ? '$item copied' : 'Copied to clipboard', duration: const Duration(seconds: 2));
  }

  /// Authentication success
  static void showAuthSuccess([String? message]) {
    showSuccess(message ?? 'Welcome back!', duration: const Duration(seconds: 2));
  }

  /// Authentication error
  static void showAuthError({String? message, String? actionLabel, VoidCallback? onActionPressed}) {
    showError(
      message ?? 'Authentication failed. Please try again.',
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: const Duration(seconds: 5),
    );
  }

  /// Bank account connected
  static void showBankConnected(String bankName) {
    showSuccess('$bankName connected successfully', duration: const Duration(seconds: 3));
  }

  /// Bank account connection error
  static void showBankConnectionError([String? bankName]) {
    showError(bankName != null ? 'Failed to connect $bankName' : 'Failed to connect bank account', actionLabel: 'RETRY', duration: const Duration(seconds: 5));
  }

  /// Network/offline error
  static void showNetworkError({String? message, VoidCallback? onRetry}) {
    showWarning(
      message ?? 'No internet connection',
      actionLabel: onRetry != null ? 'RETRY' : null,
      onActionPressed: onRetry,
      duration: const Duration(seconds: 5),
    );
  }

  /// Profile updated
  static void showProfileUpdated() {
    showSuccess('Profile updated successfully', duration: const Duration(seconds: 2));
  }

  /// Settings saved
  static void showSettingsSaved() {
    showSuccess('Settings saved', duration: const Duration(seconds: 2));
  }

  /// Feature unavailable (for Pro features)
  static void showProRequired({String? message, VoidCallback? onUpgrade}) {
    showWarning(
      message ?? 'This feature requires Vector Pro',
      actionLabel: onUpgrade != null ? 'UPGRADE' : null,
      onActionPressed: onUpgrade,
      duration: const Duration(seconds: 4),
    );
  }

  /// Generic action success
  static void showActionSuccess(String action) {
    showSuccess(action, duration: const Duration(seconds: 2));
  }

  /// Generic action error
  static void showActionError(String error, {VoidCallback? onRetry}) {
    showError(error, actionLabel: onRetry != null ? 'RETRY' : null, onActionPressed: onRetry);
  }

  // ========== Advanced Custom Notification ==========

  /// Fully customizable notification for edge cases
  static void showCustom({
    required String message,
    required NotificationType type,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
    bool? showCloseButton,
  }) {
    Color backgroundColor;
    Color foregroundColor;
    IconData defaultIcon;

    switch (type) {
      case NotificationType.success:
        backgroundColor = AppColors.success;
        foregroundColor = AppColors.textPrimary;
        defaultIcon = Icons.check_circle_rounded;
        break;
      case NotificationType.error:
        backgroundColor = AppColors.error;
        foregroundColor = Colors.white;
        defaultIcon = Icons.error_rounded;
        break;
      case NotificationType.warning:
        backgroundColor = AppColors.warning;
        foregroundColor = Colors.black87;
        defaultIcon = Icons.warning_rounded;
        break;
      case NotificationType.info:
        backgroundColor = AppColors.info;
        foregroundColor = Colors.white;
        defaultIcon = Icons.info_rounded;
        break;
      case NotificationType.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = AppColors.textPrimary;
        defaultIcon = Icons.bolt_rounded;
        break;
    }

    _show(
      message: message,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: icon ?? defaultIcon,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration ?? const Duration(seconds: 3),
      showCloseButton: showCloseButton ?? (type == NotificationType.error),
    );
  }
}
