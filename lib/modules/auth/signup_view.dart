import 'package:do_it/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class SignupPopup extends StatefulWidget {
  const SignupPopup({super.key});

  @override
  State<SignupPopup> createState() => _SignupPopupState();
}

class _SignupPopupState extends State<SignupPopup> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();

  final auth = Get.find<AuthController>();
  String? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFE8F5E9),

      title: const Text(
        "Create Account",
        style: TextStyle(color: Color(0xFF2E7D32)),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
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
          ],
        ),
      ),

      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
          ),
          onPressed: () async {
            final msg = await auth.signup(
              email: email.text.trim(),
              password: password.text.trim(),
              name: name.text.trim(),
              phone: phone.text.trim(),
            );

            if (msg != null) {
              setState(() => error = msg);
            } else {
              Get.back();
              Get.snackbar("Success", "Account created. Login now");
            }
          },
          child: const Text("Register"),
        ),
      ],
    );
  }
}
