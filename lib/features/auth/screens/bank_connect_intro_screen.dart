import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';

/// Bank connect intro screen
class BankConnectIntroScreen extends StatefulWidget {
  const BankConnectIntroScreen({super.key});

  @override
  State<BankConnectIntroScreen> createState() => _BankConnectIntroScreenState();
}

class _BankConnectIntroScreenState extends State<BankConnectIntroScreen> {
  bool _isLoading = false;

  Future<void> _handleConnectBank() async {
    setState(() => _isLoading = true);

    // Simulate bank connection flow
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/bank-connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'Connect your bank to receive payments',
                style: AppTextStyles.display2.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify account ownership and receive payments directly.',
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Vector never sees or stores your money.',
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(label: 'Connect Bank Account', onPressed: _handleConnectBank, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
