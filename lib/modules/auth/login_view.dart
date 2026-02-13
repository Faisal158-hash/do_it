import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import 'signup_view.dart';

class LoginPopup extends StatelessWidget {
  const LoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),

      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(28),
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
                /// TITLE ONLY
                const Row(
                  children: [
                    Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
                    SizedBox(width: 8),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

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

                /// LOGIN BUTTON
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
                              final success = await controller.loginUser();
                              if (success) Get.back(result: true);
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
                          : const Text("Login"),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// SIGNUP LINK
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.dialog(const SignupPopup(), barrierDismissible: true);
                  },
                  child: const Text("Create new account"),
                ),
              ],
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: _fieldDecoration(label, icon),
    );
  }

  static InputDecoration _fieldDecoration(
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
        borderSide: const BorderSide(color: Color(0xFF2E7D32)),
      ),
    );
  }
}
