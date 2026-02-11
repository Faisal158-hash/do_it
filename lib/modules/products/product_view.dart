import 'package:do_it/modules/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import 'product_controller.dart';
import 'product_card.dart';
//import '../../modules/auth/session_controller.dart'; // 🔹 Add this

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // 🔹 Inject SessionController
    //final SessionController session = Get.find<SessionController>();

    // 🔹 Check login/session immediately when page opens
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!session.isLoggedIn.value || session.showLoginPopup.value) {
    //     session.requireLogin('/products'); // 🔹 redirect after login
    //   }
    // });

    return ChangeNotifierProvider(
      create: (_) => ProductController(),
      child: Scaffold(
        appBar: const AppHeaderView(
          pageTitle: 'Products',
          cartCount: 3, // you can connect this later dynamically
        ),
        bottomNavigationBar: const AppFooter(),
        backgroundColor: const Color(0xFFF5F7F6),

        body: Consumer<ProductController>(
          builder: (context, controller, _) {
            final crossAxisCount = MediaQuery.of(context).size.width > 600
                ? 4
                : 2;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =======================
                  // SEARCH BAR
                  // =======================
                  Center(
                    child: SizedBox(
                      width: 600,
                      child: TextField(
                        onChanged: (v) =>
                            setState(() => searchQuery = v.toLowerCase()),
                        decoration: InputDecoration(
                          hintText: 'Search products / مصنوعات تلاش کریں',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.green,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =======================
                  // CATEGORY + PRODUCTS
                  // =======================
                  ...controller.productsByCategory.entries.map((entry) {
                    final products = entry.value
                        .where(
                          (p) =>
                              p.nameEn.toLowerCase().contains(searchQuery) ||
                              p.nameUr.toLowerCase().contains(searchQuery),
                        )
                        .toList();

                    if (products.isEmpty) {
                      return const SizedBox();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.categories[entry.key] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 12),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: products.length,
                          itemBuilder: (_, i) {
                            return ProductCard(product: products[i]);
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
      ),
    );
  }
}
