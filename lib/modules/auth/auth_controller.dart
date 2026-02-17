import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final box = GetStorage();

  RxBool isLoggedIn = false.obs;
  RxString userName = "".obs;   // store user name
  RxString userEmail = "".obs;  // store user email

  final int visitLimit = 5;

  @override
  void onInit() {
    super.onInit();
    checkSession();
  }

  void checkSession() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      isLoggedIn.value = true;
      userEmail.value = session.user.email ?? "";
      // fetch user name from Supabase metadata if stored
      userName.value = session.user.userMetadata?['name'] ?? "";
    } else {
      isLoggedIn.value = false;
    }
  }

  bool shouldForceLogin() {
    int visits = box.read("visits") ?? 0;
    visits++;
    box.write("visits", visits);
    return visits > visitLimit;
  }

  /// LOGIN
  Future<String?> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return "Unable to login. Register your account";
      }

      // set login state and user info
      isLoggedIn.value = true;
      userEmail.value = res.user!.email ?? "";
      userName.value = res.user!.userMetadata?['name'] ?? "";

      // reset visit counter
      box.write("visits", 0);

      // persist login info locally
      box.write("isLoggedIn", true);
      box.write("userName", userName.value);
      box.write("userEmail", userEmail.value);

      return null;
    } catch (e) {
      return "Unable to login. Register your account";
    }
  }

  /// SIGNUP
  Future<String?> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"name": name, "phone": phone},
      );

      if (res.user == null) {
        return "Unable to signup. Try again";
      }

      // set login state and user info
      isLoggedIn.value = true;
      userEmail.value = res.user!.email ?? "";
      userName.value = name;

      // persist login info locally
      box.write("isLoggedIn", true);
      box.write("userName", userName.value);
      box.write("userEmail", userEmail.value);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// LOGOUT
  void logout() {
    isLoggedIn.value = false;
    userName.value = "";
    userEmail.value = "";

    box.write("isLoggedIn", false);
    box.remove("userName");
    box.remove("userEmail");

    supabase.auth.signOut();
  }

  /// LOAD USER INFO FROM STORAGE (optional auto-login)
  void loadFromStorage() {
    final storedLoggedIn = box.read("isLoggedIn") ?? false;
    if (storedLoggedIn) {
      isLoggedIn.value = true;
      userName.value = box.read("userName") ?? "";
      userEmail.value = box.read("userEmail") ?? "";
    }
  }
}