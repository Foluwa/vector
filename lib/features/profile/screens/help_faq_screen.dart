import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_text_styles.dart';

/// Help & FAQ Screen - Common questions and answers
class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & FAQ', style: AppTextStyles.h2)),
      body: ListView(
        padding: AppConstants.paddingAll24,
        children: [
          _buildFaqItem(question: 'How do I send money?', answer: 'Tap the Pay tab, scan a QR code or enter a payment link, review the details, and confirm.'),
          _buildFaqItem(question: 'How do I receive money?', answer: 'Tap the Receive tab, generate a QR code or payment link, and share it with the sender.'),
          _buildFaqItem(
            question: 'What is a Payment Session?',
            answer:
                'Payment Sessions allow you to receive multiple payments through a single QR code. Perfect for markets, events, or collecting payments from multiple people.',
          ),
          _buildFaqItem(
            question: 'How do I connect my bank account?',
            answer: 'Go to Profile > Default Bank Account > Add Bank Account. You\'ll be guided through a secure open banking connection.',
          ),
          _buildFaqItem(
            question: 'Are my payments secure?',
            answer: 'Yes. Vector uses bank-grade encryption and open banking APIs. We never store your banking credentials.',
          ),
          _buildFaqItem(question: 'How long do payments take?', answer: 'Most payments are instant. Bank settlements typically happen within 2 hours.'),
          _buildFaqItem(question: 'What are the fees?', answer: 'Standard transactions are free. Payment Sessions have a 1.3% processing fee.'),
          _buildFaqItem(
            question: 'What is Vector Pro?',
            answer: 'Vector Pro unlocks advanced features like priority processing, analytics, custom branding, API access, and dedicated support.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(question, style: AppTextStyles.body1Medium),
      children: [
        Padding(
          padding: AppConstants.paddingH16V8.copyWith(bottom: 16),
          child: Text(answer, style: AppTextStyles.body2),
        ),
      ],
    );
  }
}
