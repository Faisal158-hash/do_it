import 'package:do_it/modules/products/product_card.dart';
import 'package:do_it/modules/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';
import 'product_controller.dart';

class ProductView extends StatefulWidget {
  final dynamic product;

  const ProductView({super.key, required this.product});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String searchQuery = '';

  final List<String> displayCategories = [
    'animal_feeds',
    'seeds',
    'fertilizers',
    'tools',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductController(),
      child: Scaffold(
        appBar: const AppHeaderView(
          pageTitle: 'Products',
          cartCount: 3,
          ordersCount: 0,
        ),
        bottomNavigationBar: const AppFooter(),
        backgroundColor: const Color(0xFFF5F5F5),
        body: Consumer<ProductController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final width = MediaQuery.of(context).size.width;
            final crossAxisCount = width > 1000
                ? 4
                : width > 700
                    ? 3
                    : 2;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔹 Search Bar
                  Center(
                    child: Container(
                      width: 450,
                      margin: const EdgeInsets.only(bottom: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => searchQuery = value.toLowerCase()),
                        decoration: const InputDecoration(
                          hintText: "Search products... / مصنوعات تلاش کریں...",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF2E7D32),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),
                  ),

                  // 🔹 Category Sections
                  ...displayCategories.map((categoryKey) {
                    final products =
                        controller.productsByCategory[categoryKey]?.where(
                      (product) {
                        return product.nameEn.toLowerCase().contains(searchQuery) ||
                            product.nameUr.toLowerCase().contains(searchQuery);
                      },
                    ).toList() ?? [];

                    if (products.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 10),
                          child: Text(
                            controller.categories[categoryKey] ??
                                categoryKey.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (_, index) {
                            return ProductCardPage(
                              product: products[index],
                              categoryId: categoryKey,
                              onAddToCart: (Product p) {
                                // Optional: directly add to cart from grid
                                controller.addToCart(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Added to Cart")),
                                );
                              },
                              // 🔹 Navigate to ConfirmOrderPage with full details
                              key: ValueKey(products[index].id),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TemperatureWidget(),
            const SizedBox(height: 8),
            const DateTimeWidget(),
          ],
        ),
      ),
    );
  }
}