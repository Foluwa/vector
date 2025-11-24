import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Terms of Service Screen - Displays terms
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms of Service', style: AppTextStyles.h2)),
      body: ListView(
        padding: AppConstants.paddingAll24,
        children: [
          Text('Terms of Service', style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            'Last updated: November 24, 2025',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: AppConstants.spacing24),

          _buildSection(
            title: '1. Acceptance of Terms',
            content: 'By using Vector, you agree to these Terms of Service. If you do not agree, please do not use our services.',
          ),

          _buildSection(
            title: '2. Service Description',
            content: 'Vector provides instant payment services using open banking technology. We facilitate peer-to-peer payments and payment sessions.',
          ),

          _buildSection(title: '3. User Eligibility', content: 'You must be at least 18 years old and have a valid UK bank account to use Vector.'),

          _buildSection(
            title: '4. Account Responsibilities',
            content: 'You are responsible for maintaining the security of your account and all activities under your account.',
          ),

          _buildSection(
            title: '5. Fees and Charges',
            content: 'Standard transactions are free. Payment Sessions incur a 1.3% processing fee. Pro subscriptions are £9/month or £90/year.',
          ),

          _buildSection(
            title: '6. Prohibited Activities',
            content: 'You may not use Vector for illegal activities, fraud, money laundering, or any purpose that violates applicable laws.',
          ),

          _buildSection(
            title: '7. Service Availability',
            content: 'We strive for 99.9% uptime but do not guarantee uninterrupted service. Maintenance windows may occur.',
          ),

          _buildSection(
            title: '8. Limitation of Liability',
            content: 'Vector is not liable for indirect, incidental, or consequential damages arising from use of our services.',
          ),

          _buildSection(title: '9. Termination', content: 'We may suspend or terminate your account for violation of these terms or illegal activity.'),

          _buildSection(title: '10. Contact', content: 'For questions about these terms, contact legal@vector.app.'),
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
