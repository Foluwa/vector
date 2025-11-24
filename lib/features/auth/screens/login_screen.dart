import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/services/notification_service.dart';
import '../services/auth_service.dart';

/// Login screen
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authStateProvider.notifier).signIn(_emailController.text, _passwordController.text);

      if (mounted) {
        context.go('/pay');
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showAuthError(message: 'Login failed. Please check your credentials.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Welcome Back', style: AppTextStyles.display2, textAlign: TextAlign.center),
                const SizedBox(height: 48),
                AppTextField(
                  label: 'Email',
                  hint: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Password',
                  hint: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                PrimaryButton(label: 'Log In', onPressed: _handleLogin, isLoading: _isLoading),
                const SizedBox(height: 24),
                Center(
                  child: AppTextButton(label: 'Don\'t have an account? Sign Up', onPressed: () => context.go('/signup')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
