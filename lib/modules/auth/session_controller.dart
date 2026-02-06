// // ignore: depend_on_referenced_packages
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:do_it/app/routes/app_routes.dart';

// class SessionController extends GetxController {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   final GetStorage _storage = GetStorage();

//   RxBool isLoggedIn = false.obs;
//   RxBool showLoginPopup = false.obs;
//   RxBool showSignupPopup = false.obs;

//   String? redirectRoute;

//   static const int sessionDurationMinutes = 30;

//   @override
//   void onInit() {
//     super.onInit();
//     _restoreSession();
//   }

//   /// 🔹 Restore session safely
//   void _restoreSession() {
//     final session = _supabase.auth.currentSession;

//     if (session == null) {
//       _clearSession();
//       isLoggedIn.value = false;
//       return;
//     }

//     // If login time missing, treat as expired
//     if (_isSessionExpired()) {
//       _clearSession();
//       isLoggedIn.value = false;
//       return;
//     }

//     isLoggedIn.value = true;
//     _storage.write('isLoggedIn', true);
//   }

//   /// 🔹 Save login time
//   // void _saveLoginTime() {
//   //   _storage.write('loginTime', DateTime.now().millisecondsSinceEpoch);
//   // }

//   /// 🔹 Session expiry check
//   bool _isSessionExpired() {
//     final int? loginTime = _storage.read('loginTime');
//     if (loginTime == null) return true;

//     final now = DateTime.now().millisecondsSinceEpoch;
//     final diffMinutes = (now - loginTime) / (1000 * 60);

//     return diffMinutes > sessionDurationMinutes;
//   }

//   /// 🔹 Clear stored session
//   void _clearSession() {
//     _storage.remove('loginTime');
//     _storage.remove('isLoggedIn');
//     redirectRoute = null;
//   }

//   /// ✅ Guarded navigation
//   // void requireLogin(String routeName) {
//   //   if (!isLoggedIn.value) {
//   //     redirectRoute = routeName;
//   //      openLogin();
//   //     return;
//   //   }

//   //   if (_isSessionExpired()) {
//   //     logout();
//   //     redirectRoute = routeName;
//   //     // openLogin();
//   //     return;
//   //   }

//   //   Get.toNamed(routeName);
//   // }

//   /// ✅ Called ONLY after successful login
//   // void onAuthSuccess() {
//   //   _saveLoginTime();
//   //   isLoggedIn.value = true;
//   //   _storage.write('isLoggedIn', true);

//   //   closePopups();

//   //   final String? route = redirectRoute;
//   //   redirectRoute = null;

//   //   if (route != null && route.isNotEmpty) {
//   //     Get.offAllNamed(route);
//   //   } else {
//   //     Get.offAllNamed(AppRoutes.home);
//   //   }
//   // }

//   // /// 🔹 Popup controls
//   // void openLogin() {
//   //   showLoginPopup.value = true;
//   //   showSignupPopup.value = false;
//   // }

//   // void openSignup() {
//   //   showSignupPopup.value = true;
//   //   showLoginPopup.value = false;
//   // }

//   // void closePopups() {
//   //   showLoginPopup.value = false;
//   //   showSignupPopup.value = false;
//   // }

//   /// 🔹 Logout
//   Future<void> logout() async {
//     await _supabase.auth.signOut();
//     _clearSession();
//     isLoggedIn.value = false;
//     Get.offAllNamed(AppRoutes.home);
//   }

//   void setSession(Session session) {}
// }
