import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/app_loggers.dart';
import '../models/doctor_model.dart';

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth =
            firebaseAuth ??
                FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges {
    return _firebaseAuth
        .authStateChanges();
  }

  User? get currentUser {
    return _firebaseAuth
        .currentUser;
  }

  DoctorModel? get currentDoctor {
    final user =
        _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return DoctorModel
        .fromFirebase(
      id: user.uid,
      email:
          user.email ?? '',
    );
  }

  Future<DoctorModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info(
        'Doctor login started',
      );

      final credential =
          await _firebaseAuth
              .signInWithEmailAndPassword(
        email:
            email.trim(),
        password:
            password,
      );

      final user =
          credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code:
              'user-not-found',
          message:
              'Doctor account was not found',
        );
      }

      AppLogger.info(
        'Doctor login successful',
      );

      return DoctorModel
          .fromFirebase(
        id: user.uid,
        email:
            user.email ?? '',
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      AppLogger.error(
        'Unexpected login error',
        error: error,
        stackTrace:
            stackTrace,
      );

      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth
          .signOut();

      AppLogger.info(
        'Doctor logged out',
      );
    } catch (
      error,
      stackTrace
    ) {
      AppLogger.error(
        'Logout failed',
        error: error,
        stackTrace:
            stackTrace,
      );

      rethrow;
    }
  }
}