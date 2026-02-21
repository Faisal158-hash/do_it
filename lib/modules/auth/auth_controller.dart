import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final box = GetStorage();

  RxBool isLoggedIn = false.obs;
  RxString userName = "".obs;
  RxString userEmail = "".obs;
  RxString userPhone = "".obs; // ⭐ ADDED (for profile page)

  final int visitLimit = 5;

  @override
  void onInit() {
    super.onInit();
    loadFromStorage(); // ⭐ load saved user first
    checkSession();
  }

  /// CHECK SUPABASE SESSION
  void checkSession() {
    final session = supabase.auth.currentSession;

    if (session != null) {
      isLoggedIn.value = true;
      userEmail.value = session.user.email ?? "";
      userName.value = session.user.userMetadata?['name'] ?? "";
      userPhone.value = session.user.userMetadata?['phone'] ?? "";

      saveUserToStorage(); // ⭐ persist data
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

  /// LOGIN (only if credentials exist in Supabase)
  Future<String?> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return "User not found. Please signup.";
      }

      // set login state
      isLoggedIn.value = true;
      userEmail.value = res.user!.email ?? "";
      userName.value = res.user!.userMetadata?['name'] ?? "";
      userPhone.value = res.user!.userMetadata?['phone'] ?? "";

      box.write("visits", 0);
      saveUserToStorage();

      return null;
    } catch (e) {
      return "Invalid email or password. Please signup first.";
    }
  }

  /// SIGNUP → store data + auto login
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

      isLoggedIn.value = true;
      userEmail.value = email;
      userName.value = name;
      userPhone.value = phone;

      saveUserToStorage();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// LOGOUT → remove profile button automatically
  Future<void> logout() async {
    await supabase.auth.signOut();

    isLoggedIn.value = false;
    userName.value = "";
    userEmail.value = "";
    userPhone.value = "";

    box.erase(); // ⭐ clear everything
  }

  /// SAVE USER DATA LOCALLY
  void saveUserToStorage() {
    box.write("isLoggedIn", true);
    box.write("userName", userName.value);
    box.write("userEmail", userEmail.value);
    box.write("userPhone", userPhone.value);
  }

  /// AUTO LOGIN FROM STORAGE
  void loadFromStorage() {
    final storedLoggedIn = box.read("isLoggedIn") ?? false;

    if (storedLoggedIn) {
      isLoggedIn.value = true;
      userName.value = box.read("userName") ?? "";
      userEmail.value = box.read("userEmail") ?? "";
      userPhone.value = box.read("userPhone") ?? "";
    }
  }
}