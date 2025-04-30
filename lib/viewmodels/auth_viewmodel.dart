import 'package:flutter/material.dart';
import 'package:audiochoosefil/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  bool _isEmailSignIn = true;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  AuthViewModel(this._authService);

  // Getters
  bool get isLoading => _isLoading;
  bool get isEmailSignIn => _isEmailSignIn;
  bool get isPasswordVisible => _isPasswordVisible;
  String? get errorMessage => _errorMessage;

  // Setters
  void setEmailSignIn(bool value) {
    _isEmailSignIn = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
