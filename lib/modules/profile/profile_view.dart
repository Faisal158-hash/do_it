import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
//import 'package:get/get.dart'; // 🔹 Add this
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import 'profile_controller.dart';
import 'profile_header.dart';
import 'profile_option_title.dart';
//import '../../modules/auth/session_controller.dart'; // 🔹 Add this

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Inject SessionController
    //final SessionController session = Get.find<SessionController>();

    // 🔹 Check login/session immediately when page opens
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!session.isLoggedIn.value || session.showLoginPopup.value) {
    //     session.requireLogin('/profile'); // 🔹 redirect after login
    //   }
    // });

    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: Scaffold(
        appBar: const AppHeaderView(pageTitle: 'Profile'),
        bottomNavigationBar: const AppFooter(),
        backgroundColor: Colors.green.shade50,
        body: Consumer<ProfileController>(
          builder: (_, controller, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    name: controller.name,
                    email: controller.email,
                    image: controller.image,
                  ),
                  const SizedBox(height: 24),
                  ProfileOptionTile(
                    icon: Icons.person,
                    title: 'Personal Info',
                    subtitle: 'Name, phone',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    icon: Icons.shopping_bag,
                    title: 'My Orders',
                    subtitle: 'View order history',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    icon: Icons.location_on,
                    title: 'Delivery Address',
                    subtitle: 'Manage addresses',
                    onTap: () {},
                  ),
                  ProfileOptionTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ProfileOptionTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out',
                    color: Colors.red.shade100,
                    onTap: () {
                      // session.logout(); // 🔹 SAFE logout
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
