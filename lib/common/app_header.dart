import 'package:do_it/modules/auth/auth_controller.dart';
import 'package:do_it/modules/auth/login_view.dart';
import 'package:flutter/material.dart';
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

  /// ---------------- NAVIGATION WITH AUTH ----------------
  Future<void> navigateWithAuth(String route) async {
    final auth = Get.find<AuthController>();

    if (!auth.isLoggedIn.value || auth.shouldForceLogin()) {
      final result = await Get.dialog(
        const LoginPopup(),
        barrierDismissible: false,
      );

      if (result == true) {
        Get.toNamed(route);
      }
    } else {
      Get.toNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController());

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final logoSize = isMobile ? 36.0 : 42.0;
    final fontSize = isMobile ? 16.0 : 18.0;
    final iconSize = isMobile ? 20.0 : 24.0;
    final horizontalPadding = isMobile ? 12.0 : 24.0;
    final navSpacing = isMobile ? 8.0 : 16.0;

    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),
      elevation: 2,
      centerTitle: false,
      automaticallyImplyLeading: false,

      /// ---------------- LOGO + TITLE ----------------
      title: Row(
        children: [
          /// Circular Logo
          CircleAvatar(
            radius: logoSize / 2,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                kAppLogo,
                height: logoSize,
                width: logoSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.store,
                    color: Colors.green,
                    size: logoSize * 0.6,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: horizontalPadding),

          /// Title
          Flexible(
            child: Text(
              pageTitle ?? 'Kisan Traders',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      /// ---------------- NAVIGATION ----------------
      actions: [
        Padding(
          padding: EdgeInsets.only(right: horizontalPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                NavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  iconSize: iconSize,
                  fontSize: fontSize - 2,
                  onTap: () => navigateWithAuth(AppRoutes.home),
                ),

                SizedBox(width: navSpacing),

                NavItem(
                  icon: Icons.storefront_outlined,
                  label: 'Products',
                  iconSize: iconSize,
                  fontSize: fontSize - 2,
                  onTap: () => navigateWithAuth(AppRoutes.product),
                ),

                SizedBox(width: navSpacing),

                NavItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Orders',
                  iconSize: iconSize,
                  fontSize: fontSize - 2,
                  onTap: () => navigateWithAuth(AppRoutes.orders),
                ),

                SizedBox(width: navSpacing),

                NavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Cart',
                  iconSize: iconSize,
                  fontSize: fontSize - 2,
                  onTap: () => navigateWithAuth(AppRoutes.cart),
                ),

                /// ⭐ ONLY PROFILE IS REACTIVE (FIXED)
                Obx(() {
                  if (!auth.isLoggedIn.value) return const SizedBox();

                  return Row(
                    children: [
                      SizedBox(width: navSpacing),
                      NavItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        iconSize: iconSize,
                        fontSize: fontSize - 2,
                        onTap: () => navigateWithAuth(AppRoutes.profile),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}

/// ================= NAV ITEM =================
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.012;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),

        /// ⭐ Prevent overflow automatically
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: iconSize),
              const SizedBox(height: 1), // reduced from 2
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}