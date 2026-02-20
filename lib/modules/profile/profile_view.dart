import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileController());

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();

  bool isInitialized = false; // prevents text reset while typing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 218, 148),

      /// HEADER
      appBar: const AppHeaderView(
        pageTitle: 'My Profile',
        cartCount: 0,
        ordersCount: 0,
      ),

      /// FOOTER
      bottomNavigationBar: const AppFooter(),

      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = controller.profile.value;

            if (profile == null) {
              return const Center(child: Text("No Profile Found"));
            }

            /// Load data only first time
            if (!isInitialized) {
              nameController.text = profile.name;
              phoneController.text = profile.phone;
              addressController.text = profile.address;
              cityController.text = profile.city;
              isInitialized = true;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  _buildTextField(nameController, "Name"),
                  _buildTextField(phoneController, "Phone"),
                  _buildTextField(addressController, "Address"),
                  _buildTextField(cityController, "City"),

                  const SizedBox(height: 20),

                  /// UPDATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.updateProfile(
                          name: nameController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          city: cityController.text,
                        );
                      },
                      child: const Text("Update Profile"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: controller.logout,
                      child: const Text("Logout"),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            );
          }),

          /// FLOATING WIDGETS (same style as HomeView)
          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}