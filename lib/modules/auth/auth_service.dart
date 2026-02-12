import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // LOGIN
  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // SIGNUP
  Future<AuthResponse> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {"name": name, "phone": phone},
    );
  }

  // LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // SESSION
  Session? getSession() {
    return supabase.auth.currentSession;
  }
}
