import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/cards.dart';
import '../../auth/services/auth_service.dart';

/// Profile screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.h1)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // User info
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                  child: Center(child: Text(user?.initials ?? 'U', style: AppTextStyles.h1)),
                ),
                const SizedBox(height: 16),
                Text(user?.displayName ?? 'User', style: AppTextStyles.h2),
                Text(user?.email ?? 'user@example.com', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SecondaryButton(label: 'Edit Profile', onPressed: () => context.push('/profile/edit'), fullWidth: false),
              ],
            ),
            const SizedBox(height: 32),
            // Vector Pro card
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.primary, size: 24),
                      const SizedBox(width: 8),
                      Text('Vector Pro', style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Unlock advanced features for power users', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ...[
                    'Priority transaction processing',
                    'Advanced analytics dashboard',
                    'Custom QR code branding',
                    'API access for integrations',
                    'Dedicated support channel',
                  ].map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(feature, style: AppTextStyles.body2),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(label: 'Go Pro — \u00A39/month', onPressed: () => context.push('/profile/pro')),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Settings section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PAYMENT SETTINGS', style: AppTextStyles.overline),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  context,
                  icon: Icons.account_balance,
                  title: 'Default Bank Account',
                  subtitle: 'Barclays ••••4892',
                  onTap: () => context.push('/profile/bank-accounts'),
                ),
                const Divider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Transaction alerts, marketing',
                  onTap: () => context.push('/profile/notifications'),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Sign Out',
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body1Medium),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
