// ignore_for_file: file_names
import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/modules/cart/cart_controller.dart';
import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:do_it/modules/products/product_controller.dart';
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
  final productController = Get.put(ProductController());

  bool isLoading = false; // for Confirm Order
  bool isLoadingCart = false; // for Add to Cart
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
    controller.phoneController.text = controller.phoneController.text.isEmpty
        ? ''
        : controller.phoneController.text;
    controller.addressController.text =
        controller.addressController.text.isEmpty
        ? ''
        : controller.addressController.text;
  }

  /// ✅ Confirm Order
  Future<void> confirmOrder() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      await controller.placeOrder(
        name_en: widget.product.nameEn,
        name_ur: widget.product.nameUr,
        image_url: widget.product.imagePath,
        quantity: quantity,
        price: widget.product.price,
      );

      Get.snackbar(
        "Success",
        "Order Confirmed",
        snackPosition: SnackPosition.BOTTOM,
      );
      controller.clearFields();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// ✅ Add to Cart
  Future<void> addToCart() async {
    if (isLoadingCart) return;
    setState(() => isLoadingCart = true);

    try {
      final supabase = Supabase.instance.client;

      await supabase.from('cart_items').insert({
        'name_en': widget.product.nameEn,
        'name_ur': widget.product.nameUr,
        'image_url': widget.product.imagePath,
        'price': widget.product.price,
        'quantity': quantity,
        'total_price': widget.product.price * quantity,
        'created_at': DateTime.now().toIso8601String(),
      });
      Get.find<CartController>().fetchCartItems();

      // Optional: update local controller/cart page if you have reactive state

      Get.snackbar(
        "Success",
        "Added to Cart",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => isLoadingCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: 'Products',
        cartCount: 3,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Place Order",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            /// PRODUCT INFO
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.imagePath,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.nameEn,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.product.nameUr,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Rs ${widget.product.price}",
                        style: TextStyle(color: colors.primary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Stock: ${widget.product.stock}",
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.product.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
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
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 20),

            /// ADD TO CART BUTTON
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: isLoadingCart
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_cart),
                label: const Text("Add to Cart"),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: addToCart,
              ),
            ),
            const SizedBox(height: 12),

            /// CONFIRM ORDER BUTTON
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
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

            /// BACK TO PRODUCTS BUTTON
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
