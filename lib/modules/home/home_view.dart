import 'dart:async';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/modules/home/banner_card.dart';
import 'package:do_it/modules/home/crop_page.dart';
import 'package:do_it/modules/home/equipment_page.dart';
import 'package:do_it/modules/home/market_page.dart';
import 'package:do_it/modules/home/organic_search.dart';
import 'package:do_it/modules/home/rates_page.dart';
import 'package:do_it/modules/home/rice_offers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/date_time_widget.dart';
import 'home_controller.dart';

// NEW PAGES
import 'subsidy_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController homeController;
  late PageController _bannerController;

  Timer? _bannerTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    homeController = Get.find<HomeController>();
    _bannerController = PageController();

    // 🔥 WELCOME POPUP
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.agriculture, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to Kisan Traders",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Live market rates & farming solutions",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });

    // 🔥 AUTO SLIDER
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || homeController.banners.isEmpty) return;

      _currentPage++;
      if (_currentPage >= homeController.banners.length) {
        _currentPage = 0;
      }

      _bannerController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: 'Home',
        cartCount: 0,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => homeController.refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _bannerSlider(),
                  const SizedBox(height: 20),
                  _categories(),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) => _testimonials(constraints),
                  ),
                  const SizedBox(height: 20),
                  _blogNews(),
                ],
              ),
            ),
          ),

          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
  

  // ---------------- BANNER ----------------
  Widget _bannerSlider() {
    return Obx(() {
      return SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _bannerController,
          itemCount: homeController.banners.length,
          itemBuilder: (context, index) {
            final b = homeController.banners[index];
            return BannerCard(
              image: b['image_url'] ?? '',
              title: b['title'] ?? '',
              subtitle: b['subtitle'] ?? '',
            );
          },
        ),
      );
    });
  }
  

  // ---------------- CATEGORIES ----------------
  Widget _categories() {
    final routes = {
      'Market': MarketPage(),
      'Crops': CropPage(),
      'Equipment': EquipmentListPage(),
      'Rates': RatesPage(),
    };

    return Obx(() {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeController.categories.length,
          itemBuilder: (context, index) {
            final c = homeController.categories[index];
            final title = c['title'] ?? '';

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (routes.containsKey(title)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => routes[title]!),
                    );
                  }
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ---------------- TESTIMONIALS ----------------
  Widget _testimonials(BoxConstraints constraints) {
    final testimonials = [
      {
        "name": "Farmer Ali",
        "text": "Kisan Traders helped me sell crops at better prices."
      },
      {
        "name": "Farmer Sana",
        "text": "I got real-time market rates and sold my wheat profitably."
      },
      {
        "name": "Farmer Bilal",
        "text": "The platform is easy to use and very reliable."
      },
    ];

    final width = constraints.maxWidth < 600 ? 250.0 : 300.0;
    final height = constraints.maxWidth < 600 ? 180.0 : 200.0;

    return _sectionWrapper(
      title: 'Success Stories',
      child: SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: testimonials.length,
          itemBuilder: (context, index) {
            return Container(
              width: width,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green.shade400,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(testimonials[index]['text']!,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text("- ${testimonials[index]['name']!}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

    // ---------------- BLOG ----------------
    Widget _blogNews() {
      final width = MediaQuery.of(context).size.width < 600 ? 220.0 : 250.0;
      final height = MediaQuery.of(context).size.width < 600 ? 180.0 : 200.0;

      return _sectionWrapper(
        title: 'Agriculture News',
        child: Obx(() {
          if (homeController.blogs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            height: height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homeController.blogs.length,
              itemBuilder: (context, index) {
                final blog = homeController.blogs[index];
                final title = (blog['title'] ?? '').toString().toLowerCase();

                return GestureDetector(
                  onTap: () {
                    // 🔥 NAVIGATION LOGIC

                    if (title.contains('subsidy')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SubsidyPage()),
                      );
                    } else if (title.contains('organic')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrganicSearchPage(),
                        ),
                      );
                    } else if (title.contains('rice')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RiceOffersPage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: width,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.green.shade300,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              blog['image_url'] ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image, size: 40),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            blog['title'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      );
    }

    Widget _sectionWrapper({required String title, required Widget child}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      );
    }
  }
