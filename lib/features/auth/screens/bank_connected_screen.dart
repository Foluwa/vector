import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';

/// Bank connected success screen
class BankConnectedScreen extends StatelessWidget {
  const BankConnectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Icon(Icons.check, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              Text('Bank connected', style: AppTextStyles.display2, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                'You\'re ready to receive payments instantly',
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(label: 'Generate First QR', onPressed: () => context.go('/receive')),
            ],
          ),
        ),
      ),
    );
  }
}
