import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'auth_controller.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final auth = Get.find<AuthController>();

  var error = RxnString();
  var isLoading = false.obs;
  var hidePassword = true.obs;

  /// REGISTER USER
  Future<bool> registerUser() async {
    // Validate fields
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      error.value = "Please fill all fields";
      return false;
    }

    // Start loading
    isLoading.value = true;
    error.value = null;

    // Call AuthController signup
    final msg = await auth.signup(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    // Stop loading
    isLoading.value = false;

    if (msg != null) {
      error.value = msg;
      return false;
    }

    // ✅ Successful signup → user info is already set in AuthController
    // Profile button will show automatically after signup
    return true;
  }

  /// OPTIONAL: Clear error when user types
  void onFieldChanged() {
    if (error.value != null) error.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}