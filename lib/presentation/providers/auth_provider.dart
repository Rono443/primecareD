import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/sources/auth_remote_source.dart';

final authSourceProvider = Provider((ref) => AuthRemoteSource());

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(ref.watch(authSourceProvider));
});

class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthRemoteSource _authSource;

  AuthNotifier(this._authSource) : super(null) {
    _init();
  }

  void _init() {
    _authSource.authStateChanges.listen((user) async {
      try {
        if (user != null) {
          state = await _authSource.getUserData(user.uid);
        } else {
          state = null;
        }
      } catch (e) {
        debugPrint('Auth listener error: $e');
        state = null;
      }
    }, onError: (e) {
      debugPrint('Auth stream error: $e');
      state = null;
    });
  }

  Future<void> login(String email, String password) async {
    try {
      state = await _authSource.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name, UserRole role) async {
    try {
      state = await _authSource.register(email, password, name, role);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authSource.logout();
    state = null;
  }
}
