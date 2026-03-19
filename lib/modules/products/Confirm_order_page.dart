import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:do_it/modules/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmOrderPage extends StatefulWidget {
  final Product product;
  const ConfirmOrderPage({super.key, required this.product});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  final controller = Get.put(OrderController());
  bool isLoading = false;
  int quantity = 1;
  late final String email;

  @override
  void initState() {
    super.initState();

    // Logged-in user
    final user = Supabase.instance.client.auth.currentUser;
    email = user?.email ?? "guest@user.com";

    // Prefill fields
    controller.nameController.text =
        user?.userMetadata?['name'] ?? controller.nameController.text;
    controller.phoneController.text =
        controller.phoneController.text.isEmpty ? '' : controller.phoneController.text;
    controller.addressController.text =
        controller.addressController.text.isEmpty ? '' : controller.addressController.text;
  }

  Future<void> confirmOrder() async {
    if (isLoading) return; // prevent duplicate clicks
    setState(() => isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // Insert into Supabase orders table
      await supabase.from('orders').insert({
        'product_name': widget.product.nameEn,
        'price': widget.product.price,
        'status': 'confirmed',
      });

      // Call controller function
      final success = await controller.placeOrder(
        productName: widget.product.nameEn,
        productNameUr: widget.product.nameUr,
        imageUrl: widget.product.imagePath,
        quantity: quantity,
        price: widget.product.price,
      );

      if (success) {
        controller.clearFields();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Order placed successfully")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all fields")),
          );
        }
      }
    } catch (e) {
      print("ERROR: $e");
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // Header/Footer same as other pages
      appBar: const AppHeaderView(
          pageTitle: 'Products',
          cartCount: 3,
          ordersCount: 0,), // your existing header function
      bottomNavigationBar:const AppFooter(), // your existing footer function
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Place Order",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Product Info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.imagePath,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.nameEn,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.product.nameUr,
                          style: TextStyle(color: colors.onSurfaceVariant)),
                      Text("Rs ${widget.product.price}",
                          style: TextStyle(color: colors.primary)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Email
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              controller: TextEditingController(text: email),
            ),
            const SizedBox(height: 12),

            // Name
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            // Phone
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone",
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            // Address
            TextField(
              controller: controller.addressController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Address",
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),

            // Quantity selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity"),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Total Price
            Text(
              "Total: Rs ${quantity * widget.product.price}",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: colors.primary),
            ),

            const SizedBox(height: 20),

            // Confirm Order button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: isLoading ? null : confirmOrder,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Confirm Order"),
              ),
            ),

            const SizedBox(height: 20),

            // Optional: Back to Products button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Products"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}