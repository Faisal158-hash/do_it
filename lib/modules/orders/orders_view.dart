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
    required this.customerPhone,
    required String productId,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  final OrderController controller = Get.put(OrderController());
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.phoneController.text = widget.customerPhone;

      /// ✅ IMPORTANT: start listening
      controller.listenToOrders(widget.customerPhone);

      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      /// ✅ FIX: HEADER MUST BE REACTIVE
      appBar:AppHeaderView(
            pageTitle: 'My Orders',
            cartCount: 0,
            ordersCount: controller.orders.length,
          ),

      bottomNavigationBar: const AppFooter(),
      backgroundColor: colors.surface,

      body: Obx(() {
        /// 🔄 LOADING
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// 📭 EMPTY STATE
        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 90,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  "No Orders Yet",
                  style: Theme.of(context).textTheme.headlineSmall,
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

        /// 📦 MULTIPLE ORDERS LIST
        return RefreshIndicator(
          color: colors.primary,
          onRefresh: () async {
            await controller.fetchOrdersOnce(widget.customerPhone);
          },
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            itemCount: controller.orders.length,

            /// ✅ FIX: better rendering stability
            itemBuilder: (context, index) {
              final order = controller.orders[index];

              /// prevent animation crash
              final safeLength =
                  controller.orders.isEmpty ? 1 : controller.orders.length;

              final animation = Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    index / safeLength,
                    1.0,
                    curve: Curves.easeOut,
                  ),
                ),
              );

              return FadeTransition(
                opacity: _animationController.drive(
                  Tween<double>(begin: 0, end: 1)
                      .chain(CurveTween(curve: Curves.easeIn)),
                ),
                child: SlideTransition(
                  position: animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: OrderCard(
                      order: order,
                      controller: controller,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}