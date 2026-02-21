// profile_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/auth_controller.dart'; // ⭐ connect auth controller
import 'profile_model.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final auth = Get.find<AuthController>(); // ⭐ use same auth state

  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();

    // fetch profile only if logged in
    if (auth.isLoggedIn.value) {
      fetchProfile();
    }

    // listen for login changes to fetch profile automatically
    ever(auth.isLoggedIn, (loggedIn) {
      if (loggedIn == true) fetchProfile();
      if (loggedIn == false) profile.value = null;
    });
  }

  /// Fetch profile from authentication user table
  Future<void> fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;

      // fetch from auth table metadata
      profile.value = ProfileModel(
        email: user.email ?? "",
        name: user.userMetadata?['name'] ?? auth.userName.value,
        phone: user.userMetadata?['phone'] ?? auth.userPhone.value, id: '',
      );

      // sync with auth controller
      auth.userName.value = profile.value!.name;
      auth.userPhone.value = profile.value!.phone;
      auth.userEmail.value = profile.value!.email;
      auth.saveUserToStorage();

    } catch (e) {
      Get.snackbar("Error fetching profile", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile in authentication table metadata
  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // update metadata directly in auth table
      await supabase.auth.updateUser(
        UserAttributes(data: {"name": name, "phone": phone}),
      );

      // update local profile
      profile.value = ProfileModel(
        email: user.email ?? "",
        name: name,
        phone: phone, id: '',
      );

      // sync with auth controller
      auth.userName.value = name;
      auth.userPhone.value = phone;
      auth.saveUserToStorage();

      Get.snackbar("Success", "Profile Updated");
    } catch (e) {
      Get.snackbar("Error updating profile", e.toString());
    }
  }

  /// Logout → clear profile + use auth controller
  Future<void> logout() async {
    try {
      profile.value = null;
      await auth.logout(); // clears auth state & header button
      Get.offAllNamed('/home'); // navigate to Home page
    } catch (e) {
      print("Logout issue: $e");
    }
  }
}