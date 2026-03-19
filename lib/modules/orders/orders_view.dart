import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'order_card.dart';

class OrderPage extends StatefulWidget {
  final String customerPhone;

  const OrderPage({
    super.key,
    required this.customerPhone, required String productId,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderController controller = Get.put(OrderController());

  @override
void initState() {
  super.initState();

  /// Fix: run after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.listenToOrders(widget.customerPhone);
  });
}
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppHeaderView(
        pageTitle: 'My Orders',
        cartCount: 0,
        ordersCount: controller.orders.length,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: colors.surface,

      body: Obx(() {
        /// LOADING STATE
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// EMPTY STATE (MODERN)
        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: colors.onSurfaceVariant,
                ),

                const SizedBox(height: 16),

                Text(
                  "No Orders Yet",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 6),

                Text(
                  "Your placed orders will appear here",
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        /// LIST VIEW WITH REFRESH
        return RefreshIndicator(
          onRefresh: () async {
            controller.listenToOrders(widget.customerPhone);
          },
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];

              return OrderCard(
                order: order,
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }
}