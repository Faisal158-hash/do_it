import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/modules/home/banner_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/date_time_widget.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController homeController;
  late final PageController _bannerController;

  @override
  void initState() {
    super.initState();

    // Use singleton controller
    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController(), permanent: true);
    }

    // Local PageController for banner slider only
    _bannerController = PageController();
  }

  @override
  void dispose() {
    _bannerController.dispose(); // Dispose only local controller
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => homeController.refreshData(),
            child: LayoutBuilder(builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final horizontalPadding = isMobile ? 12.0 : 24.0;
              final sectionSpacing = isMobile ? 24.0 : 40.0;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _searchBar(context),
                    SizedBox(height: sectionSpacing),
                    _bannerSlider(constraints),
                    SizedBox(height: sectionSpacing),
                    _platformIntro(),
                    SizedBox(height: sectionSpacing),
                    _categoriesSection(constraints),
                    SizedBox(height: sectionSpacing),
                    _featuredProducts(constraints),
                    SizedBox(height: sectionSpacing),
                    _marketRates(),
                    SizedBox(height: sectionSpacing),
                    _testimonials(constraints),
                    SizedBox(height: sectionSpacing),
                    _blogNews(constraints),
                    SizedBox(height: sectionSpacing * 2),
                  ],
                ),
              );
            }),
          ),
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _searchBar(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search crops, markets, services...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- BANNER SLIDER ----------------
  Widget _bannerSlider(BoxConstraints constraints) {
    final height = constraints.maxWidth < 600 ? 200.0 : 250.0;
    return SizedBox(
      height: height,
      child: Obx(() {
        if (homeController.banners.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return PageView.builder(
          controller: _bannerController, // use local controller
          itemCount: homeController.banners.length,
          onPageChanged: homeController.onPageChanged,
          itemBuilder: (context, index) {
            final banner = homeController.banners[index];
            final imageUrl = banner['image_url'] ?? '';
            return BannerCard(
              image: imageUrl.isNotEmpty
                  ? imageUrl
                  : 'assets/images/placeholder_banner.jpg',
              title: banner['title'] ?? 'Kisan Traders',
              subtitle: banner['subtitle'] ?? '',
            );
          },
        );
      }),
    );
  }

  // ---------------- PLATFORM INTRO ----------------
  Widget _platformIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: const Text(
        'Kisan Traders connects farmers, markets, and consumers.',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // ---------------- CATEGORIES ----------------
  Widget _categoriesSection(BoxConstraints constraints) {
    return _sectionWrapper(
      title: 'Categories',
      child: SizedBox(
        height: constraints.maxWidth < 600 ? 120 : 140,
        child: Obx(() {
          if (homeController.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.categories.length,
            itemBuilder: (context, index) {
              final category = homeController.categories[index];
              final width = constraints.maxWidth < 600 ? 140.0 : 180.0;
              return Container(
                width: width,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.tryParse(category['gradient_start'] ?? '') ??
                          0xFF4CAF50),
                      Color(int.tryParse(category['gradient_end'] ?? '') ??
                          0xFF81C784),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Center(
                  child: Text(
                    category['title'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // ---------------- FEATURED PRODUCTS ----------------
  Widget _featuredProducts(BoxConstraints constraints) {
    return _sectionWrapper(
      title: 'Featured Crops',
      child: SizedBox(
        height: constraints.maxWidth < 600 ? 180 : 200,
        child: Obx(() {
          if (homeController.featuredProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final itemWidth = constraints.maxWidth < 600 ? 140.0 : 180.0;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.featuredProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = homeController.featuredProducts[index];
              return Container(
                width: itemWidth,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.agriculture, size: 40, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(product['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Rs. ${product['price']}",
                        style: const TextStyle(color: Colors.green)),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // ---------------- MARKET RATES ----------------
  Widget _marketRates() {
    return _sectionWrapper(
      title: 'Today Market Rates',
      child: Obx(() {
        if (homeController.marketRates.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: homeController.marketRates.map((rate) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.green),
                title: Text(rate['crop_name'] ?? ''),
                trailing: Text(
                  "Rs. ${rate['price']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
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
  Widget _blogNews(BoxConstraints constraints) {
    final width = constraints.maxWidth < 600 ? 220.0 : 250.0;
    final height = constraints.maxWidth < 600 ? 180.0 : 200.0;

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
              return Container(
                width: width,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green.shade300,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.network(
                          blog['image_url'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(Icons.article),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(blog['title'] ?? '',
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // ---------------- SECTION WRAPPER ----------------
  Widget _sectionWrapper({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}