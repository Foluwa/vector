/// NotificationService Usage Examples for Vector
///
/// This file demonstrates all available notification methods
/// Copy and use these examples throughout the app

import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationExamples {
  // ========== Basic Notification Types ==========

  static void basicExamples() {
    // Success notifications (green)
    NotificationService.showSuccess('Operation completed successfully!');

    // Error notifications (red, with close button)
    NotificationService.showError('Something went wrong');
    NotificationService.showError(
      'Failed to process payment',
      actionLabel: 'RETRY',
      onActionPressed: () {
        // Retry logic here
      },
    );

    // Warning notifications (yellow/orange)
    NotificationService.showWarning('Please check your internet connection');

    // Info notifications (blue)
    NotificationService.showInfo('Your profile was viewed 5 times today');

    // Primary notifications (Vector green)
    NotificationService.showPrimary('New feature available!');
  }

  // ========== Loading States ==========

  static void loadingExamples() {
    // Show loading notification (persistent)
    NotificationService.showLoading('Syncing your data...');

    // Later, hide it when done
    NotificationService.hideAll();

    // Or show success after loading
    NotificationService.showSuccess('Sync complete!');
  }

  // ========== Payment-Specific Notifications ==========

  static void paymentExamples() {
    // Payment sent
    NotificationService.showPaymentSent(amount: '£45.00', recipient: 'Sarah Johnson');

    // Payment received
    NotificationService.showPaymentReceived(amount: '£120.50', sender: 'Michael Chen');
  }

  // ========== Session-Specific Notifications ==========

  static void sessionExamples() {
    // Session started
    NotificationService.showSessionActive(message: 'Payment session is now live', sessionId: 'SES-2024-001');

    // Session ended
    NotificationService.showSessionEnded(totalAmount: '£440.75', paymentCount: 12);
  }

  // ========== Utility Notifications ==========

  static void utilityExamples() {
    // Copied to clipboard
    NotificationService.showCopied(); // "Copied to clipboard"
    NotificationService.showCopied('Session link'); // "Session link copied"

    // Profile updated
    NotificationService.showProfileUpdated();

    // Settings saved
    NotificationService.showSettingsSaved();
  }

  // ========== Authentication Notifications ==========

  static void authExamples() {
    // Auth success
    NotificationService.showAuthSuccess();
    NotificationService.showAuthSuccess('Welcome back, John!');

    // Auth error
    NotificationService.showAuthError();
    NotificationService.showAuthError(
      message: 'Invalid credentials',
      actionLabel: 'FORGOT PASSWORD?',
      onActionPressed: () {
        // Navigate to forgot password
      },
    );
  }

  // ========== Bank Account Notifications ==========

  static void bankExamples() {
    // Bank connected
    NotificationService.showBankConnected('Monzo');

    // Bank connection error
    NotificationService.showBankConnectionError('Barclays');
  }

  // ========== Network/Error Notifications ==========

  static void networkExamples() {
    // Network error
    NotificationService.showNetworkError();
    NotificationService.showNetworkError(
      message: 'Connection lost',
      onRetry: () {
        // Retry connection logic
      },
    );
  }

  // ========== Pro/Premium Features ==========

  static void proExamples() {
    // Pro required
    NotificationService.showProRequired();
    NotificationService.showProRequired(
      message: 'Unlimited sessions require Vector Pro',
      onUpgrade: () {
        // Navigate to upgrade screen
      },
    );
  }

  // ========== Generic Actions ==========

  static void genericExamples() {
    // Generic success
    NotificationService.showActionSuccess('Note added to session');

    // Generic error
    NotificationService.showActionError(
      'Failed to update settings',
      onRetry: () {
        // Retry logic
      },
    );
  }

  // ========== Advanced Custom Notifications ==========

  static void advancedExamples() {
    // Fully customizable notification
    NotificationService.showCustom(
      message: 'Custom notification with icon',
      type: NotificationType.info,
      icon: Icons.celebration, // Custom icon
      actionLabel: 'VIEW',
      onActionPressed: () {
        // Custom action
      },
      duration: Duration(seconds: 5),
      showCloseButton: true,
    );
  }

  // ========== Real-World Usage Patterns ==========

  static void realWorldExamples() {
    // Try-catch pattern
    void performAction() async {
      try {
        NotificationService.showLoading('Processing payment...');

        // Simulate async operation
        await Future.delayed(const Duration(seconds: 2));

        NotificationService.hideAll();
        NotificationService.showSuccess('Payment sent successfully!');
      } catch (e) {
        NotificationService.hideAll();
        NotificationService.showError('Payment failed', actionLabel: 'RETRY', onActionPressed: () => performAction());
      }
    }

    // Form validation (example)
    void validateForm() {
      const emailInvalid = false;
      const passwordTooShort = false;

      if (emailInvalid) {
        NotificationService.showWarning('Please enter a valid email');
        return;
      }

      if (passwordTooShort) {
        NotificationService.showWarning('Password must be at least 8 characters');
        return;
      }

      NotificationService.showSuccess('Form validated!');
    }

    // Feature unavailable
    void onPremiumFeatureClick() {
      NotificationService.showProRequired(
        message: 'Export to CSV is a Pro feature',
        onUpgrade: () {
          // Navigate to pro pricing
        },
      );
    }

    // Prevent unused warnings
    performAction();
    validateForm();
    onPremiumFeatureClick();
  }

  // ========== Duration Variations ==========

  static void durationExamples() {
    // Short duration (1 second)
    NotificationService.showSuccess('Quick message', duration: const Duration(seconds: 1));

    // Medium duration (3 seconds - default)
    NotificationService.showInfo('Standard message');

    // Long duration (5 seconds)
    NotificationService.showError('Important error message', duration: const Duration(seconds: 5));

    // Very long (for critical errors)
    NotificationService.showError('Critical error - please contact support', duration: const Duration(seconds: 10));
  }

  // ========== Chaining Notifications ==========

  static void chainingExamples() async {
    // Sequential notifications
    NotificationService.showInfo('Starting process...');
    await Future.delayed(const Duration(seconds: 2));

    NotificationService.hideAll();
    NotificationService.showLoading('Processing step 1...');
    await Future.delayed(const Duration(seconds: 2));

    NotificationService.hideAll();
    NotificationService.showLoading('Processing step 2...');
    await Future.delayed(const Duration(seconds: 2));

    NotificationService.hideAll();
    NotificationService.showSuccess('All steps completed!');
  }
}

// Example usage in a real screen:
/*
class ExampleScreen extends StatelessWidget {
  Future<void> _sendPayment() async {
    try {
      NotificationService.showLoading('Sending payment...');
      
      // API call
      await paymentService.send(amount, recipient);
      
      NotificationService.hideAll();
      NotificationService.showPaymentSent(
        amount: '£45.00',
        recipient: 'Sarah Johnson',
      );
      
      // Navigate away
      context.go('/history');
    } catch (e) {
      NotificationService.hideAll();
      NotificationService.showError(
        'Failed to send payment',
        actionLabel: 'RETRY',
        onActionPressed: _sendPayment,
      );
    }
  }
}
*/
