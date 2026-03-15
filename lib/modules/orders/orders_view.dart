import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'order_card.dart';

class OrderPage extends StatefulWidget {
  final String customerPhone;

  const OrderPage({super.key, required this.customerPhone, required String productId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    controller.fetchOrders(widget.customerPhone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderView(
        pageTitle: 'My Orders',
        cartCount: 0, // you can dynamically fetch this later
        ordersCount: controller.orders.length,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(
              child: Text(
            "No orders found",
            style: TextStyle(fontSize: 16),
          ));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return OrderCard(order: order, controller: controller);
          },
        );
      }),
    );
  }
}