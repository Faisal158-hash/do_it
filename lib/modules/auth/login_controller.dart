// // ignore: depend_on_referenced_packages
// import 'package:do_it/app/routes/app_routes.dart';
// // ignore: depend_on_referenced_packages
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'session_controller.dart';

// class LoginController extends GetxController {
//   late final SessionController session;

//   RxBool loading = false.obs;
//   RxBool passwordVisible = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     session = Get.find<SessionController>();
//   }

//   Future<void> login(String email, String password) async {
//     final res = await Supabase.instance.client.auth.signInWithPassword(
//       email: email.trim(),
//       password: password.trim(),
//     );

//     if (res.session == null) {
//       Get.snackbar('Error', 'Login failed');
//       return;
//     }

//     Get.find<SessionController>().setSession(res.session!);

//     // ✅ NOW navigation is allowed
//     Get.offAllNamed(AppRoutes.home);
//   }

//   // /// 🔹 LOGIN METHOD
//   // Future<void> login(String email, String password) async {
//   //   if (loading.value) return;

//   //   loading.value = true;

//   //   try {
//   //     final res = await _supabase.auth.signInWithPassword(
//   //       email: email.trim(),
//   //       password: password,
//   //     );

//   //     // ❌ Invalid credentials / no session
//   //     if (res.session == null || res.user == null) {
//   //       Get.snackbar(
//   //         "Login Failed",
//   //         "Incorrect email or password.",
//   //         snackPosition: SnackPosition.TOP,
//   //       );
//   //       return;
//   //     }

//   //     // ✅ SUCCESS
//   //     // session.onAuthSuccess();

//   //     // Optional success message
//   //     Get.snackbar(
//   //       "Success",
//   //       "Login successful",
//   //       snackPosition: SnackPosition.TOP,
//   //     );
//   //   } on AuthException catch (e) {
//   //     final message = e.message.toLowerCase();

//   //     if (message.contains('invalid login credentials')) {
//   //       Get.snackbar(
//   //         "Login Failed",
//   //         "Incorrect email or password.",
//   //         snackPosition: SnackPosition.TOP,
//   //       );
//   //     } else if (message.contains('email not confirmed')) {
//   //       Get.snackbar(
//   //         "Login Failed",
//   //         "Please verify your email before logging in.",
//   //         snackPosition: SnackPosition.TOP,
//   //       );
//   //     } else {
//   //       Get.snackbar(
//   //         "Login Failed",
//   //         e.message,
//   //         snackPosition: SnackPosition.TOP,
//   //       );
//   //     }
//   //   } catch (e, s) {
//   //     // ✅ REAL error (very important)
//   //     print("LOGIN UNEXPECTED ERROR: $e");
//   //     print("STACK TRACE: $s");
//   //     Get.snackbar(
//   //       "Login Failed",
//   //       e.toString(),
//   //       snackPosition: SnackPosition.TOP,
//   //     );
//   //   } finally {
//   //     loading.value = false;
//   //   }
//   // }
// }
