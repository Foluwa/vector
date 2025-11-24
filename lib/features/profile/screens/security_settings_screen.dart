import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/notification_service.dart';

/// Security Settings Screen - Biometric login, device management
class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = true;
  bool _requirePinForPayments = false;
  bool _notifyNewDeviceLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security Settings', style: AppTextStyles.h2)),
      body: ListView(
        padding: AppConstants.paddingAll24,
        children: [
          // Biometric Authentication Section
          Text('AUTHENTICATION', style: AppTextStyles.overline),
          const SizedBox(height: AppConstants.spacing16),

          _buildSwitchTile(
            icon: Icons.fingerprint,
            title: 'Biometric Login',
            subtitle: 'Use Face ID or fingerprint to log in',
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() => _biometricEnabled = value);
              NotificationService.showSettingsSaved();
            },
          ),

          const Divider(),

          _buildSwitchTile(
            icon: Icons.lock_outline,
            title: 'PIN for Payments',
            subtitle: 'Require PIN for every payment',
            value: _requirePinForPayments,
            onChanged: (value) {
              setState(() => _requirePinForPayments = value);
              NotificationService.showSettingsSaved();
            },
          ),

          const SizedBox(height: AppConstants.spacing32),

          // Device Management Section
          Text('DEVICE MANAGEMENT', style: AppTextStyles.overline),
          const SizedBox(height: AppConstants.spacing16),

          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'New Device Login Alerts',
            subtitle: 'Get notified when your account logs in from a new device',
            value: _notifyNewDeviceLogin,
            onChanged: (value) {
              setState(() => _notifyNewDeviceLogin = value);
              NotificationService.showSettingsSaved();
            },
          ),

          const SizedBox(height: AppConstants.spacing16),

          _buildActionTile(
            icon: Icons.devices,
            title: 'Active Devices',
            subtitle: 'Manage devices with access to your account',
            onTap: () {
              _showActiveDevices(context);
            },
          ),

          const SizedBox(height: AppConstants.spacing32),

          // Password & Recovery Section
          Text('PASSWORD & RECOVERY', style: AppTextStyles.overline),
          const SizedBox(height: AppConstants.spacing16),

          _buildActionTile(
            icon: Icons.vpn_key,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              NotificationService.showInfo('Change password functionality - coming soon');
            },
          ),

          const Divider(),

          _buildActionTile(
            icon: Icons.security,
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
              child: Text(
                'RECOMMENDED',
                style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              NotificationService.showInfo('2FA setup - coming soon');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: AppConstants.paddingV8,
      child: Row(
        children: [
          Container(
            padding: AppConstants.paddingAll8,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusSmall),
            child: Icon(icon, color: AppColors.textSecondary, size: AppConstants.iconLarge),
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body1Medium),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, required String subtitle, Widget? trailing, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppConstants.paddingV12,
        child: Row(
          children: [
            Container(
              padding: AppConstants.paddingAll8,
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusSmall),
              child: Icon(icon, color: AppColors.textSecondary, size: AppConstants.iconLarge),
            ),
            const SizedBox(width: AppConstants.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body1Medium),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showActiveDevices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppConstants.paddingAll24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Active Devices', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacing16),
            _buildDeviceItem(device: 'iPhone 16 Pro Max', location: 'London, UK', lastActive: 'Active now', isCurrent: true),
            const Divider(),
            _buildDeviceItem(device: 'iPad Air', location: 'London, UK', lastActive: '2 days ago', isCurrent: false),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem({required String device, required String location, required String lastActive, required bool isCurrent}) {
    return Padding(
      padding: AppConstants.paddingV8,
      child: Row(
        children: [
          Icon(Icons.phone_iphone, color: AppColors.textSecondary),
          const SizedBox(width: AppConstants.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(device, style: AppTextStyles.body1Medium),
                    if (isCurrent) ...[
                      const SizedBox(width: AppConstants.spacing8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          'THIS DEVICE',
                          style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                Text('$location • $lastActive', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () {
                NotificationService.showSuccess('Device removed');
                Navigator.of(context).pop();
              },
              child: const Text('Remove'),
            ),
        ],
      ),
    );
  }
}
