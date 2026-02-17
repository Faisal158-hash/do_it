import 'dart:ui';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'login_controller.dart';
import 'signup_view.dart';

class LoginPopup extends StatelessWidget {
  const LoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final formKey = GlobalKey<FormState>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),

      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 400),
        tween: Tween(begin: 0.8, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },

        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),

            /// ⭐ GLASS EFFECT
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),

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

                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// ⭐ TITLE
                        const Icon(
                          Icons.lock_outline,
                          size: 45,
                          color: Color(0xFF2E7D32),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Login to continue",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                        const SizedBox(height: 25),

                        /// EMAIL FIELD
                        _modernField(
                          controller: controller.emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboard: TextInputType.emailAddress,
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

                        /// PASSWORD FIELD
                        Obx(
                          () => _modernField(
                            controller: controller.passwordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            obscure: controller.hidePassword.value,
                            suffix: IconButton(
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => controller.hidePassword.toggle(),
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

                        /// ERROR MESSAGE
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

                        const SizedBox(height: 22),

                        /// ⭐ MODERN LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 6,
                                shadowColor: Colors.green.withOpacity(.5),
                                backgroundColor: const Color(0xFF2E7D32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }

                                      final success = await controller
                                          .loginUser();
                                      if (success) Get.back(result: true);
                                    },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// SIGNUP LINK
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.dialog(
                              const SignupPopup(),
                              barrierDismissible: true,
                            );
                          },
                          child: const Text("Create new account"),
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
    );
  }

  /// ⭐ MODERN TEXT FIELD
  Widget _modernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      validator: validator,
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
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
