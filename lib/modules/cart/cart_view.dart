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
    return Scaffold(
      /// ✅ Same Header Style
      appBar: const AppHeaderView(
        pageTitle: "My Cart",
        cartCount: 0,
        ordersCount: 0,
      ),

      /// ✅ Footer Added (Same as HomeView)
      bottomNavigationBar: const AppFooter(),

      /// ✅ Same Background Color as HomeView
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [
          /// =======================
          /// CART ITEMS
          /// =======================
          FutureBuilder(
            future: controller.fetchCartItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Center(child: Text("No data found"));
              }

              final items = snapshot.data as List;

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  /// joined Product table data
                  final product = item['Product'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product['image_url'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ),
                      title: Text(
                        product['name_en'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price: Rs ${product['price']}"),
                          Text("Quantity: ${item['quantity']}"),
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
                  );
                },
              );
            },
          ),

          /// =======================
          /// FLOATING WIDGETS
          /// =======================
          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}