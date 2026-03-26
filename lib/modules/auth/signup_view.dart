import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';
import 'login_view.dart';

class SignupPopup extends StatelessWidget {
  const SignupPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final formKey = GlobalKey<FormState>();

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final dialogWidth = isMobile ? width * 0.85 : 400.0;
    final padding = isMobile ? 20.0 : 24.0;
    final iconSize = isMobile ? 40.0 : 45.0;
    final titleFont = isMobile ? 20.0 : 22.0;
    final subtitleFont = isMobile ? 13.0 : 14.0;
    final fieldFont = isMobile ? 14.0 : 16.0;
    final buttonHeight = isMobile ? 48.0 : 50.0;

    return GestureDetector(
      // ⭐ Click outside to close popup
      onTap: () => Get.back(),
      child: Material(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: GestureDetector(
            // ⭐ Prevent closing when clicking inside popup
            onTap: () {},
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 400),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: dialogWidth,
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.85),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      // ⭐ Set max height to avoid compression on small screens
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                size: iconSize,
                                color: const Color(0xFF2E7D32),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Sign up to continue",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: subtitleFont,
                                ),
                              ),
                              const SizedBox(height: 25),
                              _modernField(
                                controller: controller.nameController,
                                label: "Full Name",
                                icon: Icons.person_outline,
                                fontSize: fieldFont,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter your name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _modernField(
                                controller: controller.phoneController,
                                label: "Phone",
                                icon: Icons.phone_outlined,
                                keyboard: TextInputType.phone,
                                fontSize: fieldFont,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter phone number";
                                  }
                                  if (value.length < 10) {
                                    return "Invalid phone number";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _modernField(
                                controller: controller.emailController,
                                label: "Email",
                                icon: Icons.email_outlined,
                                keyboard: TextInputType.emailAddress,
                                fontSize: fieldFont,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter email";
                                  }
                                  if (!value.contains("@")) {
                                    return "Invalid email";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Obx(
                                () => _modernField(
                                  controller: controller.passwordController,
                                  label: "Password",
                                  icon: Icons.lock_outline,
                                  obscure: controller.hidePassword.value,
                                  fontSize: fieldFont,
                                  suffix: IconButton(
                                    icon: Icon(
                                      controller.hidePassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () =>
                                        controller.hidePassword.toggle(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length < 6) {
                                      return "Minimum 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => controller.error.value == null
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          controller.error.value!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: buttonHeight,
                                child: Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 6,
                                      shadowColor:
                                          Colors.green.withOpacity(.5),
                                      backgroundColor:
                                          const Color(0xFF2E7D32),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () async {
                                            if (!formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            final success =
                                                await controller.registerUser();
                                            if (success) {
                                              Get.back();
                                              Get.snackbar(
                                                "Success",
                                                "Account created. Login now",
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                              );
                                            }
                                          },
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: controller.isLoading.value
                                          ? SizedBox(
                                              height: buttonHeight / 2.2,
                                              width: buttonHeight / 2.2,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              "Create Account",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.dialog(
                                    const LoginPopup(),
                                    barrierDismissible: true,
                                  );
                                },
                                child: const Text(
                                  "Already have an account? Login",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    double fontSize = 16.0,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(.9),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}