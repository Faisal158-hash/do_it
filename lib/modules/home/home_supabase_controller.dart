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
    fetchHomeData();
  }

  // ---------------- MASTER FETCH ----------------
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
      // ignore: avoid_print
      print('Home data error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- HERO BANNERS ----------------
  Future<void> fetchBanners() async {
    final response = await _supabase
        .from('home_banners')
        .select()
        .eq('is_active', true)
        .order('order_no');

    banners.value = List<Map<String, dynamic>>.from(response);
  }

  // ---------------- CATEGORIES ----------------
  Future<void> fetchCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('order_no', ascending: true);

      // Make sure response is not null
      // ignore: unnecessary_null_comparison
      if (response != null) {
        categories.value = List<Map<String, dynamic>>.from(response);
        // ignore: dead_code
      } else {
        categories.clear();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching categories: $e');
      categories.clear();
    }
  }

  // ---------------- FEATURED PRODUCTS ----------------
  Future<void> fetchFeaturedProducts() async {
    final response = await _supabase
        .from('featured_products')
        .select()
        .eq('is_featured', true)
        .limit(10);

    featuredProducts.value = List<Map<String, dynamic>>.from(response);
  }

  // ---------------- MARKET RATES ----------------
  Future<void> fetchMarketRates() async {
    final response = await _supabase
        .from('market_rates')
        .select()
        .order('updated_at', ascending: false);

    marketRates.value = List<Map<String, dynamic>>.from(response);
  }

  // ---------------- BLOGS ----------------
  Future<void> fetchBlogs() async {
    try {
      final response = await _supabase
          .from('blogs')
          .select()
          .eq('is_active', true)
          .order('id', ascending: true);

      blogs.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching blogs: $e');
    }
  }
}
