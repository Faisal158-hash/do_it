// profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';
import '../auth/auth_controller.dart'; // ⭐ added
import 'profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileController());
  final auth = Get.find<AuthController>(); // ⭐ connect auth

  final Map<String, TextEditingController> fieldControllers = {};

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    // prevent access if not logged in
    if (!auth.isLoggedIn.value) {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/login');
      });
    }
  }

  @override
  void dispose() {
    // dispose all controllers dynamically
    for (var c in fieldControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Initialize fields dynamically from profile / auth data
  void _initializeControllers() {
    if (isInitialized) return;

    final profile = controller.profile.value;

    // define the fields we want dynamically
    final fields = {
      "Full Name": profile?.name ?? auth.userName.value,
      "Phone Number": profile?.phone ?? auth.userPhone.value,
      "Email": profile?.email ?? auth.userEmail.value,
    };

    // create controllers if not already
    fields.forEach((key, value) {
      fieldControllers[key] = TextEditingController(text: value);
    });

    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const AppHeaderView(
        pageTitle: 'My Profile',
        cartCount: 0,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await controller.fetchProfile();
              setState(() => isInitialized = false);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()));
                }

                _initializeControllers();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// -------- PROFILE CARD --------
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        children: fieldControllers.entries
                            .map((e) => _buildTextField(e.value, e.key))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// -------- UPDATE BUTTON --------
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Update Profile",
                            style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          controller.updateProfile(
                            name: fieldControllers["Full Name"]?.text ?? "",
                            phone: fieldControllers["Phone Number"]?.text ?? "",
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// -------- LOGOUT BUTTON --------
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text("Logout",
                            style: TextStyle(fontSize: 18, color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: controller.logout,
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                );
              }),
            ),
          ),

          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: _getIconForLabel(label),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.green.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        readOnly: label == "Email", // email is readonly
      ),
    );
  }

  /// Assign icons dynamically
  Icon _getIconForLabel(String label) {
    switch (label) {
      case "Full Name":
        return const Icon(Icons.person_outline, color: Colors.white);
      case "Phone Number":
        return const Icon(Icons.phone_android, color: Colors.white);
      case "Email":
        return const Icon(Icons.email_outlined, color: Colors.white);
      default:
        return const Icon(Icons.info_outline, color: Colors.white);
    }
  }
}