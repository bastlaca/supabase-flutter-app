import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.g.dart';

final supabase = Supabase.instance.client;

sealed class AuthState {
  const AuthState();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    _init();
    final session = supabase.auth.currentSession;
    if (session != null) {
      return AuthStateAuthenticated(session.user);
    } else {
      return const AuthStateUnauthenticated();
    }
  }

  void _init() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      state = AuthStateAuthenticated(session.user);
    }

    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        state = AuthStateAuthenticated(data.session!.user);
      } else if (data.event == AuthChangeEvent.signedOut) {
        state = const AuthStateUnauthenticated();
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Login failed, unknown user');
      }
      state = AuthStateAuthenticated(response.user!);
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      state = const AuthStateUnauthenticated();
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = const AuthStateError("Failed to sign out");
    }
  }
}
