import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Standard input field component
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.body2Medium.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          style: AppTextStyles.body1,
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.label,
            hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: AppColors.textSecondary) : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// Search field component with debouncing
class SearchField extends StatefulWidget {
  const SearchField({required this.hint, this.controller, this.onChanged, this.debounceMs, super.key});

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? debounceMs;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounceTimer;
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer
    final debounceDelay = widget.debounceMs ?? AppConstants.searchDebounceMs;
    _debounceTimer = Timer(Duration(milliseconds: debounceDelay), () {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _internalController,
      onChanged: _onSearchChanged,
      style: AppTextStyles.body1,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: _internalController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                onPressed: () {
                  _internalController.clear();
                  _onSearchChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: AppConstants.borderRadiusMedium, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: AppConstants.borderRadiusMedium, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppConstants.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.primary, width: AppConstants.borderThick),
        ),
      ),
    );
  }
}
