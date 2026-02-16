import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;

        if (profile == null) {
          return const Center(child: Text("No Profile Found"));
        }

        nameController.text = profile.name;
        phoneController.text = profile.phone;
        addressController.text = profile.address;
        cityController.text = profile.city;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Profile Avatar
              CircleAvatar(
                radius: 50,
                child: Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : "U",
                  style: const TextStyle(fontSize: 30),
                ),
              ),

              const SizedBox(height: 20),

              /// Email Card
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(profile.email),
                  subtitle: const Text("Email"),
                ),
              ),

              const SizedBox(height: 20),

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
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
