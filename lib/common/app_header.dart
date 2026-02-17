import 'package:do_it/modules/auth/auth_controller.dart';
import 'package:do_it/modules/auth/login_view.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:do_it/app/routes/app_routes.dart';

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

  /// ⭐ AUTH CHECK BEFORE NAVIGATION
  Future<void> navigateWithAuth(String route) async {
    final auth = Get.find<AuthController>();

    // if user not logged OR visit limit crossed
    if (!auth.isLoggedIn.value || auth.shouldForceLogin()) {
      final result = await Get.dialog(
        const LoginPopup(),
        barrierDismissible: false,
      );

      // if login success → go to page
      if (result == true) {
        Get.toNamed(route);
      }
    } else {
      Get.toNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),

      /// LOGO + TITLE
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Image.asset(
              kAppLogo,
              height: 36,
              width: 36,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 36,
                  width: 36,
                  child: Icon(Icons.store, color: Colors.white),
                );
              },
            ),
          ),

          const SizedBox(width: 10),
          Text(pageTitle ?? 'Kisan Traders'),
        ],
      ),

      /// NAVIGATION MENU
      actions: [
        Row(
          children: [
            NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () => navigateWithAuth(AppRoutes.home),
            ),

            NavItem(
              icon: Icons.storefront_outlined,
              label: 'Products',
              onTap: () => navigateWithAuth(AppRoutes.product),
            ),

            NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'Orders',
              onTap: () => navigateWithAuth(AppRoutes.orders),
            ),

            NavItem(
              icon: Icons.shopping_cart_outlined,
              label: 'Cart',
              onTap: () => navigateWithAuth(AppRoutes.cart),
            ),

            /// ⭐ PROFILE BUTTON: ONLY SHOW IF LOGGED IN
            Obx(() => auth.isLoggedIn.value
                ? NavItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () => navigateWithAuth(AppRoutes.profile),
                  )
                : const SizedBox.shrink() // hidden if not logged in
            ),
          ],
        ),
        const SizedBox(width: 10),
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