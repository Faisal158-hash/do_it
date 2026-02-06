// // ignore: depend_on_referenced_packages
// import 'package:get/get.dart';
// import 'session_controller.dart';

// class AuthGuard {
//   static void open(String routeName) {
//     final session = Get.find<SessionController>();

//     if (session.isLoggedIn.value) {
//       Get.toNamed(routeName);
//     } else {
//       session.requireLogin(routeName);
//     }
//   }
// }
