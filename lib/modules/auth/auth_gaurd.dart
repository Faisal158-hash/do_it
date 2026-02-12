import 'package:do_it/modules/auth/auth_controller.dart';
import 'package:do_it/modules/auth/login_view.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class AuthGuard {
  static Future<bool> check() async {
    final auth = Get.find<AuthController>();

    if (!auth.isLoggedIn.value || auth.shouldForceLogin()) {
      await Get.to(() => LoginPopup());
      return auth.isLoggedIn.value;
    }

    return true;
  }
}
