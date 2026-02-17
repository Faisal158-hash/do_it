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

  /// LOGIN USER
  Future<bool> loginUser() async {
    // Validate fields
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      error.value = "Please fill all fields";
      return false;
    }

    // Start loading
    isLoading.value = true;
    error.value = null;

    // Call AuthController login
    final msg = await auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    // Stop loading
    isLoading.value = false;

    if (msg != null) {
      error.value = msg;
      return false;
    }

    // ✅ Successful login → user info is already set in AuthController
    return true;
  }

  /// OPTIONAL: Clear error when user types
  void onFieldChanged() {
    if (error.value != null) error.value = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}