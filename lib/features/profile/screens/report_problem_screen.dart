import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/services/notification_service.dart';

/// Report a Problem Screen - Bug/issue reporting
class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Bug Report';
  bool _isSubmitting = false;

  final List<String> _problemTypes = ['Bug Report', 'App Crash', 'Payment Failed', 'UI/Design Issue', 'Performance Issue', 'Feature Not Working', 'Other'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report a Problem', style: AppTextStyles.h2)),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll24,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: AppConstants.paddingAll16,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: AppConstants.borderRadiusMedium,
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: AppConstants.spacing12),
                    Expanded(
                      child: Text(
                        'Help us improve Vector by reporting issues you encounter.',
                        style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacing24),

              // Problem type dropdown
              Text('Problem Type', style: AppTextStyles.body1Medium),
              const SizedBox(height: AppConstants.spacing8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                items: _problemTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value!);
                },
              ),
              const SizedBox(height: AppConstants.spacing20),

              // Title field
              AppTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Brief description of the problem',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacing20),

              // Description field
              Text('Description', style: AppTextStyles.body1Medium),
              const SizedBox(height: AppConstants.spacing8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What happened? What were you trying to do?',
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the problem';
                  }
                  if (value.length < 20) {
                    return 'Please provide more details (at least 20 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacing24),

              // Device info note
              Container(
                padding: AppConstants.paddingAll12,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppConstants.borderRadiusSmall),
                child: Text(
                  'Note: Device information and app version will be included automatically to help us debug.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppConstants.spacing24),

              PrimaryButton(label: _isSubmitting ? 'Submitting...' : 'Submit Report', onPressed: _isSubmitting ? null : _submitReport),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call with device info
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        NotificationService.showSuccess('Problem report submitted. Thank you!');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showError('Failed to submit report. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
