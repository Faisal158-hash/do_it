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

  Future<bool> registerUser() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      error.value = "Please fill all fields";
      return false;
    }

    isLoading.value = true;
    error.value = null;

    final msg = await auth.signup(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
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
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
