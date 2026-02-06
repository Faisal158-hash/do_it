import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
//import 'package:get/get.dart'; // 🔹 Add this
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import 'orders_controller.dart';
import 'order_card.dart';
//import '../../modules/auth/session_controller.dart'; // 🔹 Add this

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Inject SessionController
    // final SessionController session = Get.find<SessionController>();

    // 🔹 Check login/session immediately when page opens
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!session.isLoggedIn.value || session.showLoginPopup.value) {
    //     session.requireLogin('/orders'); // 🔹 redirect after login
    //   }
    // });

    return ChangeNotifierProvider(
      create: (_) => OrdersController(),
      child: Scaffold(
        appBar: const AppHeaderView(pageTitle: 'Orders', ordersCount: 5),
        bottomNavigationBar: const AppFooter(),
        backgroundColor: Colors.green.shade50,
        body: Consumer<OrdersController>(
          builder: (_, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: controller.orders.isEmpty
                  ? const Center(child: Text('No orders yet'))
                  : ListView.builder(
                      itemCount: controller.orders.length,
                      itemBuilder: (_, index) {
                        return OrderCard(order: controller.orders[index]);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
