import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ✅ Same background style (can keep your color if intentional)
      backgroundColor: const Color.fromARGB(255, 7, 218, 148),

      /// ⭐ Same Header Style
      appBar: const AppHeaderView(
        pageTitle: 'My Profile',
        cartCount: 0,
        ordersCount: 0,
      ),

      /// ✅ Footer Added (same as HomeView)
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

            /// update text controllers
            nameController.text = profile.name;
            phoneController.text = profile.phone;
            addressController.text = profile.address;
            cityController.text = profile.city;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  /// Editable Fields
                  _buildTextField(nameController, "Name"),
                  _buildTextField(phoneController, "Phone"),
                  _buildTextField(addressController, "Address"),
                  _buildTextField(cityController, "City"),

                  const SizedBox(height: 20),

                  /// Update Button
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

                  /// Logout Button
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

          /// ⭐ Temperature Widget
          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),

          /// ⭐ Date & Time Widget
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