import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/services/notification_service.dart';

/// Contact Support Screen - Support request form
class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'General Inquiry';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General Inquiry',
    'Payment Issue',
    'Bank Connection',
    'Account Problem',
    'Technical Bug',
    'Feature Request',
    'Pro Subscription',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Support', style: AppTextStyles.h2)),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll24,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We\'re here to help! Send us a message and we\'ll get back to you within 24 hours.',
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.spacing24),

              // Category dropdown
              Text('Category', style: AppTextStyles.body1Medium),
              const SizedBox(height: AppConstants.spacing8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: AppConstants.spacing20),

              // Subject field
              AppTextField(
                controller: _subjectController,
                label: 'Subject',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacing20),

              // Message field
              Text('Message', style: AppTextStyles.body1Medium),
              const SizedBox(height: AppConstants.spacing8),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Describe your issue or question...',
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  if (value.length < 10) {
                    return 'Please provide more details (at least 10 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacing32),

              PrimaryButton(label: _isSubmitting ? 'Sending...' : 'Send Message', onPressed: _isSubmitting ? null : _submitSupport),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitSupport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        NotificationService.showSuccess('Message sent! We\'ll respond within 24 hours.');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showError('Failed to send message. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
