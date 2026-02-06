import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductController extends ChangeNotifier {
  // =======================
  // CATEGORIES
  // =======================
  final Map<String, String> categories = {
    'animal_feeds': 'Animal Feeds / جانوروں کے لیے خوراک',
    'fertilizers': 'Fertilizers / کھادیں',
    'seeds': 'Seeds / بیج',
    'farming_tools': 'Farming Tools / زرعی آلات',
  };

  // =======================
  // PRODUCTS BY CATEGORY
  // =======================
  final Map<String, List<Product>> productsByCategory = {
    'animal_feeds': [
      Product(
        id: 'khal_1',
        nameEn: 'Khal',
        nameUr: 'کھاد',
        imagePath: 'assets/images/khal.png',
        price: 100,
      ),
      Product(
        id: 'chokr_1',
        nameEn: 'Chokr',
        nameUr: 'چوکر',
        imagePath: 'assets/images/chokar.png',
        price: 120,
      ),
      Product(
        id: 'wanda_1',
        nameEn: 'Wanda',
        nameUr: 'ونڈا',
        imagePath: 'assets/images/wanda.png',
        price: 150,
      ),
    ],
    'fertilizers': [
      Product(
        id: 'yuria_1',
        nameEn: 'Urea',
        nameUr: 'یوریا',
        imagePath: 'assets/images/Urea.png',
        price: 200,
      ),
      Product(
        id: 'dap_1',
        nameEn: 'DAP',
        nameUr: 'ڈی اے پی',
        imagePath: 'assets/images/dap.png',
        price: 250,
      ),
    ],
    'seeds': [
      Product(
        id: 'maize_1',
        nameEn: 'Maize',
        nameUr: 'مکئی',
        imagePath: 'assets/images/maize.png',
        price: 80,
      ),
      Product(
        id: 'wheat_1',
        nameEn: 'Wheat',
        nameUr: 'گندم',
        imagePath: 'assets/images/wheat.png',
        price: 90,
      ),
      Product(
        id: 'dhaan_1',
        nameEn: 'Dhaan',
        nameUr: 'دھان',
        imagePath: 'assets/images/dhaan.png',
        price: 80,
      ),
      Product(
        id: 'barseem_1',
        nameEn: 'Barseem',
        nameUr: 'برسیم',
        imagePath: 'assets/images/barseem.png',
        price: 80,
      ),
      Product(
        id: 'charri_1',
        nameEn: 'Charri',
        nameUr: 'چری',
        imagePath: 'assets/images/charri.png',
        price: 80,
      ),
      Product(
        id: 'haloon_1',
        nameEn: 'Haloon',
        nameUr: 'ہالون',
        imagePath: 'assets/images/haloon.png',
        price: 80,
      ),
      Product(
        id: 'maithy_1',
        nameEn: 'Maithy',
        nameUr: 'میتھی',
        imagePath: 'assets/images/maithy.png',
        price: 80,
      ),
      Product(
        id: 'raddish_1',
        nameEn: 'Raddish',
        nameUr: 'مولی',
        imagePath: 'assets/images/raddish.png',
        price: 80,
      ),
      Product(
        id: 'saroo_1',
        nameEn: 'Saroo',
        nameUr: 'سرو',
        imagePath: 'assets/images/saroo.png',
        price: 80,
      ),
      Product(
        id: 'shaljam_1',
        nameEn: 'Shaljam',
        nameUr: 'شلجم',
        imagePath: 'assets/images/shaljam.png',
        price: 80,
      ),
      Product(
        id: 'spinach_1',
        nameEn: 'Spinach',
        nameUr: 'پالک',
        imagePath: 'assets/images/spinach.png',
        price: 80,
      ),
    ],
    'farming_tools': [
      Product(
        id: 'kahi_1',
        nameEn: 'Kahi',
        nameUr: 'کائی',
        imagePath: 'assets/images/kassi.png',
        price: 300,
      ),
    ],
  };

  // =======================
  // CART
  // =======================
  final List<Product> cart = [];

  // Add product to cart
  void addToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }

  // =======================
  // ORDERS (NEW - SAFE ADDITION)
  // =======================
  final List<Product> orders = [];

  // Place order
  void placeOrder(Product product) {
    orders.add(product);
    notifyListeners();
  }

  // =======================
  // PRODUCT MANAGEMENT
  // =======================
  void addProduct(String categoryId, Product product) {
    if (productsByCategory.containsKey(categoryId)) {
      productsByCategory[categoryId]!.add(product);
    } else {
      productsByCategory[categoryId] = [product];
    }
    notifyListeners();
  }

  List<Product> getProductsByCategory(String categoryId) {
    return productsByCategory[categoryId] ?? [];
  }

  Map<String, String> getAllCategories() => categories;

  // =======================
  // COUNTS (USEFUL FOR UI BADGES)
  // =======================
  int get cartCount => cart.length;
  int get orderCount => orders.length;
}
