import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final auth = Get.find<AuthController>();

  var error = RxnString();
  var isLoading = false.obs;
  var hidePassword = true.obs;

  Future<bool> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      error.value = "Please fill all fields";
      return false;
    }

    isLoading.value = true;
    error.value = null;

    final msg = await auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    if (msg != null) {
      error.value = msg;
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
