import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Primary button component
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.label, required this.onPressed, this.isLoading = false, this.fullWidth = true, super.key});

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textTertiary,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary)),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

/// Secondary button component (outlined)
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({required this.label, required this.onPressed, this.isLoading = false, this.fullWidth = true, super.key});

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

/// Text button component
class AppTextButton extends StatelessWidget {
  const AppTextButton({required this.label, required this.onPressed, this.color, super.key});

  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: AppTextStyles.body1Medium.copyWith(color: color ?? AppColors.primary)),
    );
  }
}
