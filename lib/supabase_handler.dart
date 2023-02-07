import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  SupabaseHandler(this.client);

  final SupabaseClient client;
}

class AuthService {
  AuthService(this.client);

  final SupabaseClient client;

  Future<void> signIn(String userEmail) async {
    client.auth.signInWithOtp(email: userEmail);
  }

  Future<void> verifyOtp({
    required String userEmail,
    required String otp,
  }) async {
    await client.auth.verifyOTP(
      email: userEmail,
      token: otp,
      type: OtpType.magiclink,
    );
  }

  StreamSubscription<AuthState> listenToAuthStatus() {
    return client.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      final AuthChangeEvent event = data.event;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {

          }
          break;
      }
    });
  }

  bool isLoggedIn() {
    return client.auth.currentSession != null;
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

}

class DatabaseService {
  DatabaseService(this.client);
  final SupabaseClient client;

  void listenToTodoList() {
    client.from('todo').stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {

    });
  }
}
