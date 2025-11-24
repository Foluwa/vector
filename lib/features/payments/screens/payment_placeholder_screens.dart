// Placeholder screens for payment flows

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 120),
            const SizedBox(height: AppConstants.spacing24),
            Text('Camera view would appear here', style: AppTextStyles.body1),
            const SizedBox(height: AppConstants.spacing16),
            const Text('Point camera at QR code to scan'),
          ],
        ),
      ),
    );
  }
}

class GenerateQrScreen extends StatelessWidget {
  const GenerateQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR Code')),
      body: Padding(
        padding: AppConstants.paddingAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: AppConstants.borderRadiusLarge),
              child: const Center(child: Icon(Icons.qr_code, size: 200)),
            ),
            const SizedBox(height: AppConstants.spacing32),
            Text('Share this QR code to receive payment', style: AppTextStyles.body1, textAlign: TextAlign.center),
            const SizedBox(height: AppConstants.spacing24),
            PrimaryButton(label: 'Share', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class PaymentReviewScreen extends StatelessWidget {
  const PaymentReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Payment')),
      body: Padding(
        padding: AppConstants.paddingAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Payment Details', style: AppTextStyles.h1),
            const SizedBox(height: AppConstants.spacing32),
            Text('Amount: \u00A345.00', style: AppTextStyles.h2),
            const SizedBox(height: AppConstants.spacing16),
            const Text('To: Sarah Chen'),
            const Spacer(),
            PrimaryButton(label: 'Confirm Payment', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({required this.requestId, super.key});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Request')),
      body: Center(child: Text('Request ID: $requestId', style: AppTextStyles.body1)),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({required this.transactionId, super.key});
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: Center(child: Text('Transaction ID: $transactionId', style: AppTextStyles.body1)),
    );
  }
}

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({required this.sessionId, super.key});
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      body: Center(child: Text('Session ID: $sessionId', style: AppTextStyles.body1)),
    );
  }
}

class EmergencyTopUpScreen extends StatelessWidget {
  const EmergencyTopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Top-up')),
      body: const Center(child: Text('Emergency top-up feature')),
    );
  }
}
