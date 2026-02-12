import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final box = GetStorage();

  RxBool isLoggedIn = false.obs;

  final int visitLimit = 5;

  @override
  void onInit() {
    checkSession();
    super.onInit();
  }

  void checkSession() {
    final session = supabase.auth.currentSession;
    isLoggedIn.value = session != null;
  }

  bool shouldForceLogin() {
    int visits = box.read("visits") ?? 0;
    visits++;
    box.write("visits", visits);
    return visits > visitLimit;
  }

  Future<String?> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return "Unable to login. Register your account";
      }

      isLoggedIn.value = true;
      box.write("visits", 0);
      return null;
    } catch (e) {
      return "Unable to login. Register your account";
    }
  }

  Future<String?> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"name": name, "phone": phone},
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
