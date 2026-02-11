import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_model.dart';

class ProductController extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  // =======================
  // CATEGORIES (STATIC TITLES)
  // =======================
  final Map<String, String> categories = {
    'animal_feeds': 'Animal Feeds / جانوروں کے لیے خوراک',
    'fertilizers': 'Fertilizers / کھادیں',
    'seeds': 'Seeds / بیج',
    'farming_tools': 'Farming Tools / زرعی آلات',
  };

  // =======================
  // PRODUCTS (FROM SUPABASE)
  // =======================
  Map<String, List<Product>> productsByCategory = {};
  bool isLoading = true;

  // =======================
  // CART
  // =======================
  final List<Product> cart = [];

  ProductController() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.from('Product').select();

      productsByCategory.clear();

      for (final item in response) {
        final product = Product.fromMap(item);
        productsByCategory
            .putIfAbsent(product.categoryId, () => [])
            .add(product);
      }
    } catch (e) {
      debugPrint('Product fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }

  int get cartCount => cart.length;
}
