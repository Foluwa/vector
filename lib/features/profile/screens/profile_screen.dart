import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
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
        padding: AppConstants.paddingAll24,
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
                const SizedBox(height: AppConstants.spacing16),
                Text(user?.displayName ?? 'User', style: AppTextStyles.h2),
                Text(user?.email ?? 'user@example.com', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppConstants.spacing16),
                SecondaryButton(label: 'Edit Profile', onPressed: () => context.push('/profile/edit'), fullWidth: false),
              ],
            ),
            const SizedBox(height: AppConstants.spacing32),
            // Vector Pro card
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.primary, size: AppConstants.iconLarge),
                      const SizedBox(width: AppConstants.spacing8),
                      Text('Vector Pro', style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  Text('Unlock advanced features for power users', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppConstants.spacing16),
                  ...[
                    'Priority transaction processing',
                    'Advanced analytics dashboard',
                    'Custom QR code branding',
                    'API access for integrations',
                    'Dedicated support channel',
                  ].map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacing8),
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: AppConstants.iconSmall, color: AppColors.primary),
                          const SizedBox(width: AppConstants.spacing8),
                          Text(feature, style: AppTextStyles.body2),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  PrimaryButton(label: 'Go Pro — \u00A39/month', onPressed: () => context.push('/profile/pro')),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacing32),
            // Settings section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PAYMENT SETTINGS', style: AppTextStyles.overline),
                const SizedBox(height: AppConstants.spacing16),
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
              ],
            ),
            const SizedBox(height: 32),

            // Support & Help section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SUPPORT & HELP', style: AppTextStyles.overline),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & FAQ',
                  subtitle: 'Common questions and answers',
                  onTap: () => context.push('/profile/help'),
                ),
                const Divider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.support_agent,
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  onTap: () => context.push('/profile/support'),
                ),
                const Divider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Problem',
                  subtitle: 'Submit bug reports or feedback',
                  onTap: () => context.push('/profile/report'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Legal & Security section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LEGAL & SECURITY', style: AppTextStyles.overline),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  onTap: () => context.push('/profile/privacy'),
                ),
                const Divider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Our terms and conditions',
                  onTap: () => context.push('/profile/terms'),
                ),
                const Divider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.shield_outlined,
                  title: 'Security Settings',
                  subtitle: 'Biometrics, PIN, active devices',
                  onTap: () => context.push('/profile/security'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Version label
            Center(
              child: Text('Version 1.0.0', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 24),

            // Enhanced logout button
            OutlinedButton(
              onPressed: () => _showLogoutDialog(context, ref),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                foregroundColor: AppColors.error,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Sign Out', style: AppTextStyles.body1Medium.copyWith(color: AppColors.error)),
            ),
            const SizedBox(height: 24),
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

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out', style: AppTextStyles.h3),
        content: Text('Are you sure you want to sign out?', style: AppTextStyles.body2),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTextStyles.body1Medium),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authStateProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
            child: Text('Sign Out', style: AppTextStyles.body1Medium.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
