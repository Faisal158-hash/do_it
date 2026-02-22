import 'package:do_it/modules/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/temperature_widget.dart';
import '../../common/date_time_widget.dart';
import 'product_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, required product});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductController(),
      child: Scaffold(
        /// Header (same style as HomeView)
        appBar: const AppHeaderView(
          pageTitle: 'Products',
          cartCount: 3,
          ordersCount: 0,
        ),

        /// Footer
        bottomNavigationBar: const AppFooter(),

        /// Background
        backgroundColor: const Color(0xFFF5F5F5),

        body: Stack(
          children: [
            /// MAIN CONTENT
            Consumer<ProductController>(
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
                final contentWidth = width > 700 ? 700.0 : width * 0.95;

                return Center(
                  child: Container(
                    width: contentWidth,
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// SEARCH BAR
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search products / مصنوعات تلاش کریں',
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// CATEGORY SECTIONS
                          ...controller.productsByCategory.entries.map((entry) {
                            final categoryId = entry.key;
                            final categoryTitle =
                                controller.categories[categoryId] ?? '';

                            final filteredProducts = entry.value.where((product) {
                              return product.nameEn
                                      .toLowerCase()
                                      .contains(searchQuery) ||
                                  product.nameUr
                                      .toLowerCase()
                                      .contains(searchQuery);
                            }).toList();

                            if (filteredProducts.isEmpty) {
                              return const SizedBox();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// CATEGORY TITLE
                                Text(
                                  categoryTitle,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                /// PRODUCTS GRID
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
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (_, index) {
                                    return ProductCardPage(
                                      product: filteredProducts[index],
                                      categoryId: '',
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),
                              ],
                            );
                          }),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            /// FLOATING WIDGETS (TEMPERATURE & DATETIME)
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: TemperatureWidget(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: const DateTimeWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}