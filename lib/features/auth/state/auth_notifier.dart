import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shattok/data/providers/auth_provider.dart';
import 'package:shattok/data/repositories/auth_repository.dart';
import 'package:shattok/data/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState()) {
    _initialize();
  }

  void _initialize() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      state = state.copyWith(user: UserModel.fromFirebaseUser(user));
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        error: 'Email and password are required',
        isLoading: false,
      );
      return;
    }

    try {
      final user = await _authRepository.signIn(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        error: _mapFirebaseError(e.code),
        isLoading: false,
      );
    } catch (e, stackTrace) {
      _logError('Unexpected error during sign-in', e, stackTrace);
      state =
          state.copyWith(error: 'Unexpected error occurred', isLoading: false);
    }
  }

  String _mapFirebaseError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'User not found. Please register or check your email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }

  void _logError(String message, Object error, StackTrace stackTrace) {
    // Implementa un sistema de logs o utiliza un servicio como Sentry
    debugPrint('$message: $error\n$stackTrace');
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.signOut();
      state = AuthState(); // Restablece el estado
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});
