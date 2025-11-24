import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/cards.dart';

/// Receive screen - central hub for receiving payments
class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receive', style: AppTextStyles.h1)),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActionCard(
              title: 'Receive Payment',
              subtitle: 'Generate QR or link to get paid',
              icon: Icons.qr_code,
              isPrimary: true,
              onTap: () => context.push('/receive/generate-qr'),
            ),
            const SizedBox(height: AppConstants.spacing16),
            ActionCard(title: 'Scan to Pay', subtitle: 'Scan a QR code to pay someone', icon: Icons.qr_code_scanner, onTap: () => context.push('/pay/scan')),
            const SizedBox(height: AppConstants.spacing16),
            ActionCard(title: 'Emergency Top-up', subtitle: 'Quick access to funds', icon: Icons.bolt, onTap: () => context.push('/receive/emergency-topup')),
            const SizedBox(height: AppConstants.spacing24),
            // Expandable "How Vector works"
            ExpansionTile(
              title: Text('How Vector works', style: AppTextStyles.body1Medium),
              children: [
                Padding(
                  padding: AppConstants.paddingAll16,
                  child: Text(
                    'Generate a QR code or payment link to receive money instantly. Share it with anyone, and they can pay you directly to your connected bank account.',
                    style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacing24),
            Text('Active Requests', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacing16),
            // Mock active requests
            _buildActiveRequest(context, amount: '£45.00', name: 'Sarah Chen', time: '2 min ago', id: '1'),
            const SizedBox(height: AppConstants.spacing12),
            _buildActiveRequest(context, amount: '£120.50', name: 'Marcus Johnson', time: '15 min ago', id: '2'),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildActiveRequest(BuildContext context, {required String amount, required String name, required String time, required String id}) {
    return InkWell(
      onTap: () => context.push('/receive/request/$id'),
      borderRadius: AppConstants.borderRadiusLarge,
      child: Container(
        padding: AppConstants.paddingAll16,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppConstants.borderRadiusLarge,
          border: Border.all(color: AppColors.border, width: AppConstants.borderThin),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(amount, style: AppTextStyles.h2),
                  const SizedBox(height: AppConstants.spacing4),
                  Text(name, style: AppTextStyles.body1),
                  Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppConstants.spacing8),
                  Row(
                    children: [
                      Container(
                        width: AppConstants.spacing8,
                        height: AppConstants.spacing8,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: AppConstants.spacing8),
                      Text('Waiting for payment', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: AppConstants.paddingAll12,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: AppConstants.borderRadiusSmall),
              child: const Icon(Icons.qr_code, color: AppColors.primary, size: AppConstants.iconLarge),
            ),
          ],
        ),
      ),
    );
  }
}
