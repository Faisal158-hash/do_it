import 'package:do_it/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminLoginController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final box = GetStorage();

  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  Future<void> login() async {
    try {
      isLoading.value = true;

      final res = await supabase.auth.signInWithPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      final user = res.user;

      if (user == null) {
        Get.snackbar("Error", "Invalid login credentials");
        return;
      }

      // ✅ store auth data only
      box.write('userId', user.id);
      box.write('email', user.email);

      // 🔥 TEMP LOGIC: admin check via email (since no table now)
      if (user.email == 'admin@gmail.com') {
        box.write('role', 'admin');
        Get.offAllNamed(AppRoutes.admin);
      } else {
        box.write('role', 'user');
        Get.offAllNamed(AppRoutes.home);
      }
    } on AuthException catch (e) {
      Get.snackbar("Login Failed", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
