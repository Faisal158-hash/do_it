import 'package:do_it/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
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

      if (res.user == null) {
        Get.snackbar("Error", "Invalid login");
        return;
      }

      final userId = res.user!.id;

      final data = await supabase
          .from('Admin_Profile')
          .select('role')
          .eq('id', userId)
          .single();

      String role = data['role'];

      box.write('role', role);

      // ROUTING
      if (role == 'admin') {
        Get.offAllNamed(AppRoutes.admin);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}