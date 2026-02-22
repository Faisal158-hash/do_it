import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';
import '../auth/auth_controller.dart';
import 'profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileController());
  final auth = Get.find<AuthController>();

  final Map<String, TextEditingController> fieldControllers = {};
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    if (!auth.isLoggedIn.value) {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/login');
      });
    }
  }

  @override
  void dispose() {
    for (var c in fieldControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    if (isInitialized) return;

    final profile = controller.profile.value;

    final fields = {
      "Full Name": profile?.name ?? auth.userName.value,
      "Phone Number": profile?.phone ?? auth.userPhone.value,
      "Email": profile?.email ?? auth.userEmail.value,
    };

    fields.forEach((key, value) {
      fieldControllers[key] = TextEditingController(text: value);
    });

    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 700 ? 600.0 : width * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
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
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()));
                }

                _initializeControllers();

                return Center(
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      _buildGlassCard(cardWidth),
                      const SizedBox(height: 30),
                      _buildUpdateButton(),
                      const SizedBox(height: 16),
                      _buildLogoutButton(),
                      const SizedBox(height: 120),
                    ],
                  ),
                );
              }),
            ),
          ),

          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 25,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Icon(Icons.person, size: 70, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          auth.userName.value.isEmpty ? "User" : auth.userName.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          auth.userEmail.value,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ],
    );
  }

  // ================= GLASS CARD =================

  Widget _buildGlassCard(double cardWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            children: fieldControllers.entries
                .map((e) => _buildTextField(e.value, e.key))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ================= UPDATE BUTTON =================

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: const Text("Update Profile", style: TextStyle(fontSize: 17)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          elevation: 6,
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
    );
  }

  // ================= LOGOUT BUTTON =================

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text("Logout",
            style: TextStyle(fontSize: 17, color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: controller.logout,
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        controller: controller,
        readOnly: label == "Email",
        decoration: InputDecoration(
          prefixIcon: _getIconForLabel(label),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Icon _getIconForLabel(String label) {
    switch (label) {
      case "Full Name":
        return const Icon(Icons.person_outline);
      case "Phone Number":
        return const Icon(Icons.phone_android);
      case "Email":
        return const Icon(Icons.email_outlined);
      default:
        return const Icon(Icons.info_outline);
    }
  }
}