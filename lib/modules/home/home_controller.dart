import 'dart:async';
import 'package:flutter/material.dart';

/// HomeController
/// Responsible ONLY for UI behavior (PageView auto sliding)
/// Does NOT handle data fetching (Supabase does that)
class HomeController {
  // ---------------- PAGE CONTROLLER ----------------
  final PageController pageController = PageController();

  // ---------------- STATE ----------------
  int currentPage = 0;
  int totalBanners = 0; // 🔹 dynamic (comes from Supabase)
  Timer? _timer;

  // ---------------- SET BANNER COUNT ----------------
  /// Call this when banners are loaded from Supabase
  void setBannerCount(int count) {
    totalBanners = count;

    // Reset page if needed
    if (currentPage >= totalBanners) {
      currentPage = 0;
      if (pageController.hasClients) {
        pageController.jumpToPage(0);
      }
    }
  }

  // ---------------- AUTO SLIDE ----------------
  void startAutoSlide() {
    // Always cancel previous timer
    _timer?.cancel();

    // Safety checks
    if (totalBanners <= 1) {
      return; // No need to auto slide
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients) return;

      currentPage = (currentPage + 1) % totalBanners;

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  // ---------------- MANUAL PAGE CHANGE ----------------
  /// Optional: call this if user swipes manually
  void onPageChanged(int index) {
    currentPage = index;
  }

  // ---------------- CLEANUP ----------------
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
  }

  void showSignupPopup() {}
}
