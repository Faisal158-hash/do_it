import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import 'cart_controller.dart';
import 'cart_item_card.dart';
import 'cart_summary.dart';
//import '../../modules/auth/session_controller.dart';
// ignore: depend_on_referenced_packages
//import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // final SessionController session = Get.find<SessionController>();

    // 🔹 Check login/session immediately when page opens
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!session.isLoggedIn.value || session.showLoginPopup.value) {
    //     session.requireLogin('/cart'); // 🔹 Ensure redirect after login
    //   }
    // });

    return ChangeNotifierProvider(
      create: (_) => CartController(),
      child: Scaffold(
        appBar: const AppHeaderView(pageTitle: 'My Cart', cartCount: 4),
        bottomNavigationBar: const AppFooter(),
        backgroundColor: Colors.green.shade50,
        body: Consumer<CartController>(
          builder: (_, controller, _) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.cartItems.isEmpty
                        ? const Center(child: Text('Cart is empty'))
                        : ListView.builder(
                            itemCount: controller.cartItems.length,
                            itemBuilder: (_, index) {
                              return CartItemCard(
                                item: controller.cartItems[index],
                              );
                            },
                          ),
                  ),
                ),
                CartSummary(total: controller.totalPrice),
              ],
            );
          },
        ),
      ),
    );
  }
}
