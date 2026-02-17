// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeSupabaseController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ---------------- OBSERVABLE DATA ----------------

  /// Hero Banners
  var banners = <Map<String, dynamic>>[].obs;

  /// Categories
  var categories = <Map<String, dynamic>>[].obs;

  /// Featured Products
  var featuredProducts = <Map<String, dynamic>>[].obs;

  /// Market Rates
  var marketRates = <Map<String, dynamic>>[].obs;

  /// Blogs
  var blogs = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  // ---------------- LIFECYCLE ----------------
  @override
  void onInit() {
    super.onInit();
    fetchAll(); // ⭐ unified method
  }

  // =====================================================
  // ⭐ MASTER FETCH (used by HomeView)
  // =====================================================

  Future<void> fetchAll() async {
    await fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        fetchBanners(),
        fetchCategories(),
        fetchFeaturedProducts(),
        fetchMarketRates(),
        fetchBlogs(),
      ]);
    } catch (e) {
      print("Home data error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // HERO BANNERS
  // =====================================================

  Future<void> fetchBanners() async {
    try {
      final response = await _supabase
          .from('home_banners')
          .select()
          .eq('is_active', true)
          .order('order_no');

      banners.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Banner error: $e");
      banners.clear();
    }
  }

  // =====================================================
  // CATEGORIES
  // =====================================================

  Future<void> fetchCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('order_no', ascending: true);

      categories.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Categories error: $e");
      categories.clear();
    }
  }

  // =====================================================
  // FEATURED PRODUCTS
  // =====================================================

  Future<void> fetchFeaturedProducts() async {
    try {
      final response = await _supabase
          .from('featured_products')
          .select()
          .eq('is_featured', true)
          .limit(10);

      featuredProducts.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Featured products error: $e");
      featuredProducts.clear();
    }
  }

  // =====================================================
  // MARKET RATES
  // =====================================================

  Future<void> fetchMarketRates() async {
    try {
      final response = await _supabase
          .from('market_rates')
          .select()
          .order('updated_at', ascending: false);

      marketRates.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Market rates error: $e");
      marketRates.clear();
    }
  }

  // =====================================================
  // BLOGS
  // =====================================================

  Future<void> fetchBlogs() async {
    try {
      final response = await _supabase
          .from('blogs')
          .select()
          .eq('is_active', true)
          .order('id', ascending: true);

      blogs.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Blogs error: $e");
      blogs.clear();
    }
  }

  // =====================================================
  // ⭐ OPTIONAL: Pull-to-refresh support
  // =====================================================

  Future<void> refreshData() async {
    await fetchAll();
  }
}