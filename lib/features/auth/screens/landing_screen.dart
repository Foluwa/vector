import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/buttons.dart';

/// Landing screen - first screen users see
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppConstants.paddingAll24,
          child: Column(
            children: [
              const Spacer(),
              // Branding block
              Column(
                children: [
                  Text('Vector', style: AppTextStyles.display1.copyWith(color: AppColors.primary, fontSize: 48)),
                  const SizedBox(height: AppConstants.spacing8),
                  Text('Money in Motion', style: AppTextStyles.h2),
                  const SizedBox(height: AppConstants.spacing48),
                  // QR scan frame icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: const Icon(Icons.qr_code_scanner, size: 64, color: AppColors.primary),
                  ),
                ],
              ),
              const Spacer(),
              // Primary actions
              Column(
                children: [
                  Text('No wallet. No delay. Pure joy', style: AppTextStyles.h3, textAlign: TextAlign.center),
                  const SizedBox(height: AppConstants.spacing8),
                  Text(
                    'Scan or share QR to pay or get paid in seconds.',
                    style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacing32),
                  PrimaryButton(label: 'Pay Someone', onPressed: () => context.push('/pay')),
                  const SizedBox(height: AppConstants.spacing12),
                  Text('No signup required', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppConstants.spacing24),
                  SecondaryButton(label: 'Get Paid', onPressed: () => context.push('/receive')),
                  const SizedBox(height: AppConstants.spacing32),
                  // Footer actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextButton(label: 'Log In', onPressed: () => context.push('/login'), color: AppColors.textPrimary),
                      const SizedBox(width: AppConstants.spacing32),
                      AppTextButton(label: 'Sign Up', onPressed: () => context.push('/signup')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
