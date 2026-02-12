import 'package:do_it/modules/auth/auth_controller.dart';
import 'package:do_it/modules/auth/signup_view.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = Get.find<AuthController>();

  String? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFE8F5E9),

      title: const Text("Login", style: TextStyle(color: Color(0xFF2E7D32))),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),

          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),

          TextButton(
            onPressed: () {
              Get.back();
              Get.dialog(const SignupPopup());
            },
            child: const Text("Register Account"),
          ),
        ],
      ),

      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
          ),
          onPressed: () async {
            final msg = await auth.login(
              email.text.trim(),
              password.text.trim(),
            );

            if (msg != null) {
              setState(() => error = msg);
            } else {
              Get.back(result: true);
            }
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}
