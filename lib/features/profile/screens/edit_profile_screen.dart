import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Edit your profile information', style: AppTextStyles.body1),
            const Spacer(),
            PrimaryButton(label: 'Save Changes', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notification settings')),
    );
  }
}
