import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/avatars.dart';

/// Pay screen - main entry for making payments
class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay', style: AppTextStyles.h1),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show info dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How Vector Works'),
                  content: const Text('Scan a QR code or enter a payment link to send money instantly.'),
                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Got it'))],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scan to Pay card
            InkWell(
              onTap: () => context.push('/pay/scan'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 32, color: AppColors.textPrimary),
                    const SizedBox(width: 16),
                    Text('Scan to Pay', style: AppTextStyles.h3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Manual entry
            Text('Or enter payment link', style: AppTextStyles.body2Medium),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'vector.app/pay/...',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.push('/pay/review');
                }
              },
            ),
            const SizedBox(height: 32),
            // Recent recipients
            Text('Recent', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  RecipientChip(initials: 'SC', name: 'Sarah Chen', onTap: () => context.push('/pay/review')),
                  RecipientChip(initials: 'JO', name: 'James Okoye', onTap: () => context.push('/pay/review')),
                  RecipientChip(initials: 'MS', name: 'Maria Santos', onTap: () => context.push('/pay/review')),
                  RecipientChip(initials: 'DK', name: 'David Ki', onTap: () => context.push('/pay/review')),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Start Payment Session',
              onPressed: () {
                // Handle payment session
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
