import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartController controller = Get.put(CartController());

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
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await controller.placeOrder(
                name: nameController.text,
                address: addressController.text,
                phone: phoneController.text,
              );
              Navigator.pop(context);
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
      appBar: const AppHeaderView(
        pageTitle: "My Cart",
        cartCount: 0,
        ordersCount: 0,
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
                child: Text("Your cart is empty", style: TextStyle(fontSize: 18)),
              );
            }

            final items = controller.cartItems;

            return RefreshIndicator(
              onRefresh: controller.fetchCartItems,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) {
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
                          child: Image.network(item.imageUrl),
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
                          onPressed: () => controller.removeItem(item.id!),
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCheckoutDialog(context),
        label: const Text("Order Now"),
        icon: const Icon(Icons.shopping_cart_checkout),
      ),
    );
  }
}