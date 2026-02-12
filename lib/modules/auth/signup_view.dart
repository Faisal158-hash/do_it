import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';

class SignupPopup extends StatelessWidget {
  const SignupPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),

      child: Center(
        child: Container(
          width: 300, // ⭐ FIXED WIDTH
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(28),

            /// ⭐ MODERN SHADOW
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TOP BAR (TITLE + CLOSE)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person_add_alt_1, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),

                    /// CLOSE BUTTON
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// FULL NAME
                _modernField(
                  controller: controller.nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 12),

                /// PHONE
                _modernField(
                  controller: controller.phoneController,
                  label: "Phone",
                  icon: Icons.phone_outlined,
                  keyboard: TextInputType.phone,
                ),

                const SizedBox(height: 12),

                /// EMAIL
                _modernField(
                  controller: controller.emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 12),

                /// PASSWORD
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.hidePassword.value,
                    decoration: _fieldDecoration(
                      "Password",
                      Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          controller.hidePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => controller.hidePassword.toggle(),
                      ),
                    ),
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

                const SizedBox(height: 18),

                /// REGISTER BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              final success = await controller.registerUser();

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
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ⭐ REUSABLE MODERN FIELD
  Widget _modernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: _fieldDecoration(label, icon),
    );
  }

  /// ⭐ MODERN INPUT STYLE
  InputDecoration _fieldDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(.8),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
      ),
    );
  }
}
