import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/modules/home/home_supabase_controller.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
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
  late HomeSupabaseController data;
  late HomeController controller;

  @override
  void initState() {
    super.initState();

    /// Initialize controllers safely
    data = Get.put(HomeSupabaseController(), permanent: true);
    controller = Get.put(HomeController(), permanent: true);

    controller.startAutoSlide();
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
          /// Pull to refresh
          RefreshIndicator(
            onRefresh: () async {
              data.fetchAll(); // make sure this exists in controller
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _searchBar(),
                  const SizedBox(height: 20),
                  _bannerSlider(),
                  const SizedBox(height: 40),
                  _platformIntro(),
                  const SizedBox(height: 40),
                  _categoriesSection(),
                  const SizedBox(height: 40),
                  _featuredProducts(),
                  const SizedBox(height: 40),
                  _marketRates(),
                  const SizedBox(height: 40),
                  _testimonials(),
                  const SizedBox(height: 40),
                  _blogNews(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
  // ---------------- SEARCH BAR ----------------
  Widget _searchBar() {
    return Center(
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search crops, markets, services...',
              prefixIcon: const Icon(Icons.search),
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
    );
  }

  // ---------------- BANNER SLIDER ----------------
  Widget _bannerSlider() {
    return SizedBox(
      height: 200,
      child: Obx(() {
        if (data.banners.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: controller.pageController,
          itemCount: data.banners.length,
          itemBuilder: (context, index) {
            final banner = data.banners[index];

            return Image.network(
              banner['image_url'] ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.error)),
            );
          },
        );
      }),
    );
  }

  // ---------------- PLATFORM INTRO ----------------
  Widget _platformIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text(
          'Kisan Traders connects farmers, markets, and consumers.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // ---------------- CATEGORIES ----------------
  Widget _categoriesSection() {
    return _sectionWrapper(
      title: 'Categories',
      child: SizedBox(
        height: 120,
        child: Obx(() {
          if (data.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 12,
              childAspectRatio: 3.5,
            ),
            itemBuilder: (context, index) {
              final category = data.categories[index];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.tryParse(category['gradient_start']) ??
                          0xFF4CAF50),
                      Color(int.tryParse(category['gradient_end']) ??
                          0xFF81C784),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
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
  Widget _featuredProducts() {
    return _sectionWrapper(
      title: 'Featured Crops',
      child: SizedBox(
        height: 180,
        child: Obx(() {
          if (data.featuredProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.featuredProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = data.featuredProducts[index];

              return Container(
                width: 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.agriculture,
                        size: 40, color: Colors.greenAccent),
                    Text(product['name'] ?? '',
                        style: const TextStyle(color: Colors.white)),
                    Text("Rs. ${product['price']}",
                        style: const TextStyle(color: Colors.greenAccent)),
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
        if (data.marketRates.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: data.marketRates.map((rate) {
            return ListTile(
              leading: const Icon(Icons.trending_up),
              title: Text(rate['crop_name'] ?? ''),
              trailing: Text(
                "Rs. ${rate['price']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  // ---------------- TESTIMONIALS ----------------
  Widget _testimonials() {
    final testimonials = [
      {
        "name": "Farmer Ali",
        "text": "Kisan Traders helped me sell crops at better prices.",
      },
      {
        "name": "Farmer Sana",
        "text": "I got real-time market rates and sold my wheat profitably.",
      },
      {
        "name": "Farmer Bilal",
        "text": "The platform is easy to use and very reliable.",
      },
    ];

    return _sectionWrapper(
      title: 'Success Stories',
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: testimonials.length,
          itemBuilder: (context, index) {
            return Container(
              width: 250,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green.shade400,
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
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
    return _sectionWrapper(
      title: 'Agriculture News',
      child: Obx(() {
        if (data.blogs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.blogs.length,
            itemBuilder: (context, index) {
              final blog = data.blogs[index];

              return Container(
                width: 220,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green.shade300,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        blog['image_url'] ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.article),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(blog['title'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
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
  Widget _sectionWrapper({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}