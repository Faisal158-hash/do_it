import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  // ✅ Safe controller initialization
  final CartController controller =
      Get.isRegistered<CartController>()
          ? Get.find<CartController>()
          : Get.put(CartController());

  void showCheckoutDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Checkout"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty ||
                  addressController.text.trim().isEmpty ||
                  phoneController.text.trim().isEmpty) {
                Get.snackbar(
                  "Error",
                  "Please fill all fields",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                );
                return;
              }

              await controller.placeOrder(
                name: nameController.text.trim(),
                address: addressController.text.trim(),
                phone: phoneController.text.trim(),
              );

              if (Navigator.canPop(context)) Navigator.pop(context);

              Get.snackbar(
                "Success",
                "Your order has been placed!",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade100,
              );
            },
            child: const Text("Place Order"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width > 700 ? 650.0 : width * 0.95);

    return Scaffold(
      // ✅ Reactive AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => AppHeaderView(
              pageTitle: "My Cart",
              cartCount: controller.totalItems,
              ordersCount: 0,
            )),
      ),

      bottomNavigationBar: const AppFooter(),
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.cartItems.isEmpty) {
              return const Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final items = controller.cartItems;

            return RefreshIndicator(
              onRefresh: controller.fetchCartItems,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 100),
                itemCount: items.length + 1,
                itemBuilder: (_, index) {
                  if (index == items.length) {
                    // ✅ TOTAL CARD
                    return Center(
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rs ${controller.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final item = items[index];

                  return Center(
                    child: Container(
                      width: cardWidth,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.95),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: item.imageUrl.isEmpty
                              ? const Icon(Icons.image_not_supported)
                              : Image.network(
                                  item.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                        ),
                        title: Text(
                          item.nameEn,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: Rs ${item.price}"),
                            Text("Quantity: ${item.quantity}"),
                            Text("Total: Rs ${item.totalPrice}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: item.id == null
                              ? null
                              : () async {
                                  await controller.removeItem(item.id!);

                                  Get.snackbar(
                                    "Removed",
                                    "Item removed from cart",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),

      // ✅ Improved Order Button
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            onPressed: controller.cartItems.isEmpty
                ? null
                : () => showCheckoutDialog(context),
            label: controller.isLoading.value
                ? const Text("Processing...")
                : const Text("Order Now"),
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.shopping_cart_checkout),
          )),
    );
  }
}