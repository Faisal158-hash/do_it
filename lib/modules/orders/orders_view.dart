import 'package:do_it/common/app_header.dart';
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
      // ✅ USING YOUR HEADER
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppHeaderView(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            TextField(
              controller: controller.phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),

            TextField(
              controller: controller.addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity"),
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
                    Text(quantity.toString()),
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
          ],
        ),
      ),
    );
  }
}
