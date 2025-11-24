import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Privacy Policy Screen - Displays privacy policy
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy', style: AppTextStyles.h2)),
      body: ListView(
        padding: AppConstants.paddingAll24,
        children: [
          Text('Privacy Policy', style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            'Last updated: November 24, 2025',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: AppConstants.spacing24),

          _buildSection(
            title: '1. Information We Collect',
            content:
                'Vector collects information necessary to provide secure payment services, including your name, email address, bank account details (via open banking), and transaction history.',
          ),

          _buildSection(
            title: '2. How We Use Your Information',
            content:
                'We use your information to process payments, prevent fraud, comply with legal obligations, and improve our services. We never sell your personal data.',
          ),

          _buildSection(
            title: '3. Data Security',
            content: 'We employ bank-grade encryption and security measures to protect your data. All bank connections use secure open banking APIs.',
          ),

          _buildSection(
            title: '4. Data Sharing',
            content: 'We only share your data with authorized payment processors and banking partners necessary to complete transactions.',
          ),

          _buildSection(
            title: '5. Your Rights',
            content: 'You have the right to access, correct, or delete your personal data. Contact us at privacy@paywithvector.app.',
          ),

          _buildSection(
            title: '6. Cookies and Tracking',
            content: 'We use essential cookies for app functionality. No third-party advertising cookies are used.',
          ),

          _buildSection(title: '7. Contact Us', content: 'For privacy questions, email privacy@paywithvector.app or contact support in the app.'),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.body1Medium),
          const SizedBox(height: AppConstants.spacing8),
          Text(content, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
