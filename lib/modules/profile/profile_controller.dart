import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_model.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  /// Fetch logged user profile
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      profile.value = ProfileModel.fromJson(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String city,
  }) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      await supabase
          .from('profiles')
          .update({
            'name': name,
            'phone': phone,
            'address': address,
            'city': city,
          })
          .eq('id', user.id);

      fetchProfile();
      Get.snackbar("Success", "Profile Updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }
}
