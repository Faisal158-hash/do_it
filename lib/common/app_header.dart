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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),

      /// ✅ LOGO + TITLE
      title: Row(
        children: [
          /// Logo
          ClipRRect(
            borderRadius: BorderRadius.zero, // makes it square
            child: Image.asset(
              kAppLogo,
              height: 36,
              width: 36,
              fit: BoxFit.cover,

              /// if logo not found → show icon instead
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

          /// Title
          Text(pageTitle ?? 'Kisan Traders'),
        ],
      ),

      /// Navigation menu
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
            ),
            NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () => Get.toNamed(AppRoutes.profile),
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
