import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../auth/services/auth_service.dart';
import '../widgets/user_profile_header.dart';
import '../widgets/vector_pro_card.dart';
import '../widgets/settings_tile.dart';

/// Profile screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.h1)),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll24,
        child: Column(
          children: [
            // User info header
            UserProfileHeader(onEditPressed: () => context.push('/profile/edit')),
            const SizedBox(height: AppConstants.spacing32),

            // Vector Pro card
            VectorProCard(onUpgradePressed: () => context.push('/profile/pro')),
            const SizedBox(height: AppConstants.spacing32),

            // Payment Settings section
            _buildSettingsSection(
              context,
              title: 'PAYMENT SETTINGS',
              tiles: [
                (icon: Icons.account_balance, title: 'Default Bank Account', subtitle: 'Barclays ••••4892', route: '/profile/bank-accounts'),
                (icon: Icons.notifications_outlined, title: 'Notifications', subtitle: 'Transaction alerts, marketing', route: '/profile/notifications'),
              ],
            ),
            const SizedBox(height: AppConstants.spacing32),

            // Support & Help section
            _buildSettingsSection(
              context,
              title: 'SUPPORT & HELP',
              tiles: [
                (icon: Icons.help_outline, title: 'Help & FAQ', subtitle: 'Common questions and answers', route: '/profile/help'),
                (icon: Icons.support_agent, title: 'Contact Support', subtitle: 'Get help from our team', route: '/profile/support'),
                (icon: Icons.bug_report_outlined, title: 'Report a Problem', subtitle: 'Submit bug reports or feedback', route: '/profile/report'),
              ],
            ),
            const SizedBox(height: AppConstants.spacing32),

            // Legal & Security section
            _buildSettingsSection(
              context,
              title: 'LEGAL & SECURITY',
              tiles: [
                (icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', subtitle: 'How we handle your data', route: '/profile/privacy'),
                (icon: Icons.description_outlined, title: 'Terms of Service', subtitle: 'Our terms and conditions', route: '/profile/terms'),
                (icon: Icons.shield_outlined, title: 'Security Settings', subtitle: 'Biometrics, PIN, active devices', route: '/profile/security'),
              ],
            ),
            const SizedBox(height: AppConstants.spacing32),

            // Version label
            Center(
              child: Text('Version 1.0.0', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: AppConstants.spacing24),

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
            const SizedBox(height: AppConstants.spacing24),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<({IconData icon, String title, String subtitle, String route})> tiles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.overline),
        const SizedBox(height: AppConstants.spacing16),
        ...tiles.asMap().entries.map((entry) {
          final index = entry.key;
          final tile = entry.value;
          return Column(
            children: [
              SettingsTile(icon: tile.icon, title: tile.title, subtitle: tile.subtitle, onTap: () => context.push(tile.route)),
              if (index < tiles.length - 1) const Divider(),
            ],
          );
        }),
      ],
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
