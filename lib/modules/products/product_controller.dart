import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_model.dart';

class ProductController extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  final Map<String, String> categories = {
    'animal_feeds': 'Animal Feeds / جانوروں کے لیے خوراک',
    'fertilizers': 'Fertilizers / کھادیں',
    'seeds': 'Seeds / بیج',
    'farming_tools': 'Farming Tools / زرعی آلات',
  };

  // 🔹 Mapping Supabase values → internal keys
  final Map<String, String> categoryMap = {
    'Seeds/بیج': 'seeds',
    'Fertilizers/کھادیں': 'fertilizers',
    'Animal Feeds/ جانوروں کے لیے خوراک': 'animal_feeds',
    'Farming Tools/ زرعی آلات': 'farming_tools',
  };

  Map<String, List<Product>> productsByCategory = {};
  bool isLoading = true;

  final List<Product> cart = [];

  ProductController() {
    fetchProducts();
  }

  /// Fetch all products from Supabase including Description and Stock
  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.from('Product').select();
      productsByCategory.clear();

      for (final item in response) {
        final product = Product.fromMap(item);

        // 🔹 Map Supabase category to Flutter internal key
        final categoryKey =
            categoryMap[product.categoryId] ?? product.categoryId;

        // Add product to correct category
        productsByCategory.putIfAbsent(categoryKey, () => []).add(product);

        debugPrint(
          'Product fetched: ${product.nameEn}, Category: $categoryKey, Image: ${product.imagePath}, Stock: ${product.stock}',
        );
      }
    } catch (e) {
      debugPrint('Product fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  /// Fetch single product by ID (optional: for lazy loading on View Details)
  Future<Product?> fetchProductById(String id) async {
  try {
    final response = await supabase
        .from('Product')
        .select()
        .eq('id', id)
        .maybeSingle(); // ← replaced .execute()

    if (response != null) {
      return Product.fromMap(response);
    }
  } catch (e) {
    debugPrint('Fetch single product error: $e');
  }
  return null;
}

  void addToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }

  int get cartCount => cart.length;
}
