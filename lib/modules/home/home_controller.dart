// ignore: depend_on_referenced_packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ---------------- OBSERVABLE DATA ----------------
  var banners = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var featuredProducts = <Map<String, dynamic>>[].obs;
  var marketRates = <Map<String, dynamic>>[].obs;
  var blogs = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  // ---------------- PAGE CONTROLLER ----------------
  final PageController pageController = PageController();
  int currentPage = 0;
  Timer? _timer;

  // ---------------- LIFECYCLE ----------------
  @override
  void onInit() {
    super.onInit();
    fetchAll(); // fetch all home data
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
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

      // After fetching banners, setup page slider
      setBannerCount(banners.length);
      startAutoSlide();
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

      // Optional: Add placeholder if no banners
      if (banners.isEmpty) {
        banners.add({'image_url': ''}); // empty string will trigger placeholder
      }
    } catch (e) {
      print("Banner error: $e");
      banners.clear();
      banners.add({'image_url': ''}); // fallback placeholder
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
  // AUTO SLIDE BANNER ----------------
  // =====================================================
  void setBannerCount(int count) {
    if (count == 0) return;

    if (currentPage >= count) {
      currentPage = 0;
      if (pageController.hasClients) pageController.jumpToPage(0);
    }
  }

  void startAutoSlide() {
    _timer?.cancel();
    if (banners.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients) return;

      currentPage = (currentPage + 1) % banners.length;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int index) {
    currentPage = index;
  }

  // =====================================================
  // ⭐ REFRESH DATA (Pull-to-refresh)
  // =====================================================
  Future<void> refreshData() async {
    await fetchAll();
  }
}