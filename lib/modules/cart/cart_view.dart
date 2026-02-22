import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'package:flutter/material.dart';
import 'cart_controller.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final controller = CartController();

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width > 700 ? 650 : width * 0.95).toDouble();

    return Scaffold(
      /// Header
      appBar: const AppHeaderView(
        pageTitle: "My Cart",
        cartCount: 0,
        ordersCount: 0,
      ),

      /// Footer
      bottomNavigationBar: const AppFooter(),

      /// Background
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [
          /// CART ITEMS
          FutureBuilder(
            future: controller.fetchCartItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              final items = snapshot.data as List;

              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item['Product'];

                    return Center(
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product['image_url'] ?? '',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            product['name_en'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Price: Rs ${product['price'] ?? '0'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Quantity: ${item['quantity'] ?? 1}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await controller.removeItem(item['id']);
                              refresh();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          /// FLOATING WIDGETS
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}