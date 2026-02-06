import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:do_it/app/routes/app_routes.dart';
//import 'package:do_it/modules/auth/session_controller.dart';

const String kAppLogo = 'assets/images/logo.jpg';

class AppHeaderView extends StatelessWidget implements PreferredSizeWidget {
  final int cartCount;
  final int ordersCount;
  final String? pageTitle;

  const AppHeaderView({
    super.key,
    this.cartCount = 0,
    this.ordersCount = 0,
    this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    // final session = Get.find<SessionController>();

    // void navigate(String route, {bool requireLogin = false}) {
    //   if (requireLogin && !session.isLoggedIn.value) {
    //     session.requireLogin(route);
    //     return;
    //   }
    //   session.redirectRoute = null;
    //   if (Get.currentRoute != route) {
    //     Get.toNamed(route);
    //   }
    // }

    // // ignore: avoid_print
    // print("Session exists: ${Get.isRegistered<SessionController>()}");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: const Color(0xFF2E7D32),
          title: const Text('Kisan Traders'),
          actions: [
            Row(
              children: [
                NavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  onTap: () => Get.toNamed(AppRoutes.home),
                ),
                NavItem(
                  icon: Icons.storefront_outlined,
                  label: 'Products',
                  onTap: () => Get.toNamed(AppRoutes.product),
                  //requireLogin: true
                ),
                NavItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Orders',
                  onTap: () => Get.toNamed(AppRoutes.orders),
                ),
                NavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Cart',
                  onTap: () => Get.toNamed(AppRoutes.cart),
                  //requireLogin: true
                ),
                NavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  onTap: () => Get.toNamed(AppRoutes.profile),

                  //requireLogin: true
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
