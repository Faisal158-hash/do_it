import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:do_it/modules/orders/orders_controller.dart';

class OrderPage extends StatefulWidget {
  final String productId;

  const OrderPage({super.key, required this.productId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final controller = OrderController();
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ⭐ Same Header Style as HomeView
      appBar: const AppHeaderView(
        pageTitle: 'Orders',
        cartCount: 0,
        ordersCount: 0,
      ),

      /// ⭐ Added Footer (Same as HomeView)
      bottomNavigationBar: const AppFooter(),

      /// ⭐ Same background as HomeView
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [
          /// Scrollable Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  /// Name
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Phone
                  TextField(
                    controller: controller.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Address
                  TextField(
                    controller: controller.addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => quantity++);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Place Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await controller.placeOrder(
                          widget.productId,
                          quantity,
                        );

                        if (!context.mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order placed successfully"),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Fill all fields")),
                          );
                        }
                      },
                      child: const Text("Place Order"),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          /// ⭐ Temperature Widget
          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),

          /// ⭐ Date & Time Widget
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}