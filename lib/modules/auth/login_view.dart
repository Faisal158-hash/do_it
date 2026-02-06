// import 'dart:ui';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:get/get.dart';

// import 'package:do_it/modules/auth/login_controller.dart';
// import 'package:do_it/modules/auth/session_controller.dart';

// class LoginPopup extends StatefulWidget {
//   const LoginPopup({super.key});

//   @override
//   State<LoginPopup> createState() => _LoginPopupState();
// }

// class _LoginPopupState extends State<LoginPopup> {
//   late final LoginController controller;
//   late final SessionController session;

//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     // ✅ Safe controller resolution
//     controller = Get.isRegistered<LoginController>()
//         ? Get.find<LoginController>()
//         : Get.put(LoginController());

//     session = Get.find<SessionController>();
//   }

//   @override
//   void dispose() {
//     email.dispose();
//     password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (!session.showLoginPopup.value) {
//         return const SizedBox.shrink();
//       }

//       return Center(
//         child: Material(
//           color: Colors.black.withOpacity(0.4),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: SingleChildScrollView(
//               child: Container(
//                 width: 380,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.green.shade50.withOpacity(0.95),
//                       Colors.green.shade100.withOpacity(0.9),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(26),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 25,
//                       offset: Offset(0, 12),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Welcome Back 🌾",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     const Text(
//                       "Login to Kisan Traders",
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     const SizedBox(height: 25),

//                     // Email
//                     TextField(
//                       controller: email,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         hintText: "Email address",
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),

//                     // Password
//                     TextField(
//                       controller: password,
//                       obscureText: !controller.passwordVisible.value,
//                       decoration: InputDecoration(
//                         hintText: "Password",
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             controller.passwordVisible.value
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                           onPressed: controller.passwordVisible.toggle,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 26),

//                     // Login button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: controller.loading.value
//                             ? null
//                             : () async {
//                                 await controller.login(
//                                   email.text.trim(),
//                                   password.text.trim(),
//                                 );
//                               },
//                         child: controller.loading.value
//                             ? const CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               )
//                             : const Text(
//                                 "Login",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // TextButton(
//                     //   onPressed: session.openSignup,
//                     //   child: const Text(
//                     //     "Create new account",
//                     //     style: TextStyle(fontWeight: FontWeight.w600),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
