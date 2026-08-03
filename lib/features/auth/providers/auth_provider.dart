
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_loggers.dart';
import '../models/doctor_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
  }) : _authService =
            authService ??
                AuthService();

  final AuthService _authService;

  bool _isLoading = false;

  String? _errorMessage;

  DoctorModel? _doctor;

  bool get isLoading =>
      _isLoading;

  String? get errorMessage =>
      _errorMessage;

  DoctorModel? get doctor =>
      _doctor;

  bool get isLoggedIn =>
      _doctor != null;

  Stream<User?> get authStateChanges {
    return _authService
        .authStateChanges;
  }

  void loadCurrentDoctor() {
    _doctor =
        _authService
            .currentDoctor;

    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    _errorMessage = null;

    try {
      _doctor =
          await _authService
              .signIn(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (
      error
    ) {
      _errorMessage =
          _getFirebaseError(
        error,
      );

      AppLogger.error(
        'Firebase login failed',
        error: error,
      );

      return false;
    } catch (
      error,
      stackTrace
    ) {
      _errorMessage =
          'Something went wrong. Please try again.';

      AppLogger.error(
        'Login failed',
        error: error,
        stackTrace:
            stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> logout() async {
    _setLoading(true);

    try {
      await _authService
          .signOut();

      _doctor = null;

      return true;
    } catch (
      error,
      stackTrace
    ) {
      _errorMessage =
          'Unable to logout. Please try again.';

      AppLogger.error(
        'Logout failed',
        error: error,
        stackTrace:
            stackTrace,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }

  void _setLoading(
    bool value,
  ) {
    _isLoading = value;

    notifyListeners();
  }

  String _getFirebaseError(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address';

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password';

      case 'user-disabled':
        return 'This doctor account has been disabled';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later';

      case 'network-request-failed':
        return 'No internet connection. Please try again';

      default:
        return error.message ??
            'Login failed. Please try again';
    }
  }
}

