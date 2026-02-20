// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_model.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    fetchOrCreateProfile();
    super.onInit();
  }

  /// FETCH OR CREATE PROFILE
  Future<void> fetchOrCreateProfile() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle(); // important change

      /// If profile doesn't exist → create it
      if (data == null) {
        await createProfile(user);
      } else {
        profile.value = ProfileModel.fromJson(data);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// CREATE PROFILE (first time login)
  Future<void> createProfile(User user) async {
    try {
      final newProfile = {
        'id': user.id,
        'name': user.userMetadata?['name'] ?? '',
        'phone': user.phone ?? '',
        'address': '',
        'city': '',
      };

      await supabase.from('profiles').insert(newProfile);

      /// fetch again after create
      await fetchOrCreateProfile();
    } catch (e) {
      Get.snackbar("Profile Create Error", e.toString());
    }
  }

  /// UPDATE PROFILE
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String city,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('profiles').upsert({
        'id': user.id,
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
      });

      await fetchOrCreateProfile();
      Get.snackbar("Success", "Profile Updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }
}