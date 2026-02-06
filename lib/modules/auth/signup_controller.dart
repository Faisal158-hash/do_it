// // ignore: depend_on_referenced_packages
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'session_controller.dart';

// class SignupController extends GetxController {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   // SAFE: ensure SessionController exists
//   final SessionController session = Get.find<SessionController>();

//   RxBool loading = false.obs;
//   RxBool passwordVisible = false.obs;

//   Future<void> signup(String email, String password, String name) async {
//     if (loading.value) return;
//     loading.value = true;

//     try {
//       final res = await _supabase.auth.signUp(
//         email: email.trim(),
//         password: password,
//       );

//       final user = res.user;

//       if (user == null) {
//         Get.snackbar("Signup Failed", "Account could not be created");
//         return;
//       }

//       await _supabase.from('users').insert({
//         'id': user.id,
//         'email': email.trim(),
//         'name': name.trim(),
//       });

//       Get.snackbar("Success", "Account created successfully");

//       // session.onAuthSuccess();
//     } on AuthException catch (e) {
//       Get.snackbar("Signup Failed", e.message);
//     } catch (_) {
//       Get.snackbar("Signup Failed", "Something went wrong");
//     } finally {
//       loading.value = false;
//     }
//   }
// }
