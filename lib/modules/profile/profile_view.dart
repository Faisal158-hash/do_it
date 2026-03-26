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
  final profilecontroller = Get.put(ProfileController());
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

    final profile = profilecontroller.profile.value;

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
              await profilecontroller.fetchProfile();
              setState(() => isInitialized = false);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                if (profilecontroller.isLoading.value) {
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
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 4,
              )
            ],
          ),
          child: const Icon(Icons.person, size: 80, color: Colors.white),
        ),
        const SizedBox(height: 14),
        Text(
          auth.userName.value.isEmpty ? "User" : auth.userName.value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          auth.userEmail.value,
          style: TextStyle(color: Colors.grey[700], fontSize: 15),
        ),
      ],
    );
  }

  // ================= GLASS CARD =================

  Widget _buildGlassCard(double cardWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.35), Colors.white.withOpacity(0.15)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 25,
                offset: const Offset(0, 12),
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
      width: 200,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          profilecontroller.updateProfile(
            name: fieldControllers["Full Name"]?.text ?? "",
            phone: fieldControllers["Phone Number"]?.text ?? "",
          );
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(8),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF388E3C);
            }
            return const Color(0xFF4CAF50);
          }),
          shadowColor: MaterialStateProperty.all(Colors.greenAccent.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.save, size: 22),
            SizedBox(width: 10),
            Text("Update Profile", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT BUTTON =================

  Widget _buildLogoutButton() {
    return SizedBox(
      width: 200,
      height: 55,
      child: OutlinedButton(
        onPressed: profilecontroller.logout,
        style: ButtonStyle(
          side: MaterialStateProperty.all(const BorderSide(color: Colors.red, width: 2)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
          shadowColor: MaterialStateProperty.all(Colors.redAccent.withOpacity(0.3)),
          elevation: MaterialStateProperty.all(4),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text("Logout", style: TextStyle(fontSize: 17, color: Colors.red, fontWeight: FontWeight.w600)),
          ],
        ),
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
          fillColor: Colors.white.withOpacity(0.25),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
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