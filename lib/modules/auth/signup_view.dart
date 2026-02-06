// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:do_it/modules/auth/signup_controller.dart';
// import 'package:do_it/modules/auth/session_controller.dart';

// class SignupPopup extends StatelessWidget {
//   SignupPopup({super.key});

//   // ✅ REGISTER controllers safely
//   final SignupController controller = Get.put(SignupController());
//   final SessionController session = Get.find<SessionController>();

//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (!session.showSignupPopup.value) {
//         return const SizedBox.shrink();
//       }

//       return Center(
//         child: Material(
//           color: Colors.black.withOpacity(0.4),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: SingleChildScrollView(
//               child: Container(
//                 width: 400,
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
//                       "Join Kisan Traders 🌾",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     const Text(
//                       "Create your account",
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     const SizedBox(height: 25),

//                     // 🔹 Full Name
//                     TextField(
//                       controller: name,
//                       decoration: InputDecoration(
//                         hintText: "Full Name",
//                         prefixIcon: const Icon(Icons.person_outline),
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),

//                     // 🔹 Email
//                     TextField(
//                       controller: email,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         hintText: "Email Address",
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

//                     // 🔹 Password
//                     Obx(
//                       () => TextField(
//                         controller: password,
//                         obscureText: !controller.passwordVisible.value,
//                         decoration: InputDecoration(
//                           hintText: "Password",
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               controller.passwordVisible.value
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: controller.passwordVisible.toggle,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 26),

//                     // 🔹 Signup Button
//                     Obx(
//                       () => SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton(
//                           onPressed: controller.loading.value
//                               ? null
//                               : () {
//                                   controller.signup(
//                                     email.text.trim(),
//                                     password.text.trim(),
//                                     name.text.trim(),
//                                   );
//                                 },
//                           child: controller.loading.value
//                               ? const CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 )
//                               : const Text("Create Account"),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // 🔹 Switch to Login
//                     TextButton(
//                       onPressed: () {
//                         session.showSignupPopup.value = false;
//                         Future.microtask(() {
//                           session.showLoginPopup.value = true;
//                         });
//                       },
//                       child: const Text(
//                         "Already have an account? Login",
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
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
