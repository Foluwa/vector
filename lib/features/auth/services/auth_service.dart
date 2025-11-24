import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

/// Mock authentication service
class AuthService {
  UserModel? _currentUser;

  /// Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    _currentUser = UserModel(id: 'user_${DateTime.now().millisecondsSinceEpoch}', email: email, name: _extractNameFromEmail(email));

    return _currentUser!;
  }

  /// Sign up with email and password
  Future<UserModel> signUp(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    _currentUser = UserModel(id: 'user_${DateTime.now().millisecondsSinceEpoch}', email: email, name: _extractNameFromEmail(email));

    return _currentUser!;
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  /// Get current user
  UserModel? getCurrentUser() {
    return _currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }

  String _extractNameFromEmail(String email) {
    final username = email.split('@').first;
    return username.split('.').map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)).join(' ');
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier(this._authService) : super(null) {
    state = _authService.getCurrentUser();
  }

  final AuthService _authService;

  Future<void> signIn(String email, String password) async {
    final user = await _authService.signIn(email, password);
    state = user;
  }

  Future<void> signUp(String email, String password) async {
    final user = await _authService.signUp(email, password);
    state = user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }
}
