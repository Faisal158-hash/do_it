import 'package:do_it/common/temperature_widget.dart';
//import 'package:do_it/modules/auth/login_view.dart';
//import 'package:do_it/modules/auth/session_controller.dart';
//import 'package:do_it/modules/auth/signup_view.dart';
import 'package:do_it/modules/home/home_supabase_controller.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/date_time_widget.dart';
//import 'banner_card.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  final HomeSupabaseController data = Get.put(
    HomeSupabaseController(),
    permanent: true,
  );

  final HomeController homeController = Get.put(
    HomeController(),
    permanent: true,
  );
  // final session = Get.put(SessionController());
  // final SessionController session = Get.find();

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController get controller => widget.homeController;

  @override
  void initState() {
    super.initState();
    controller.startAutoSlide();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: 'Home',
        cartCount: 2,
        ordersCount: 1,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: const Color.fromARGB(255, 7, 218, 148),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                _farmerBenefits(),
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

          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),

          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),

          // 🔽 AUTH POPUPS (FIXED: CLOSE ON OUTSIDE TAP)
          // Obx(() {
          //   if (widget.session.showSignupPopup.value) {
          //     return Stack(
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             widget.session.showSignupPopup.value = false;
          //           },
          //           child: Container(
          //             // ignore: deprecated_member_use
          //             color: Colors.black.withOpacity(0.5),
          //             width: double.infinity,
          //             height: double.infinity,
          //           ),
          //         ),
          //         Center(child: SignupPopup()),
          //       ],
          //     );
          //   }

          //   if (widget.session.showLoginPopup.value) {
          //     return Stack(
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             widget.session.showLoginPopup.value = false;
          //           },
          //           child: Container(
          //             // ignore: deprecated_member_use
          //             color: Colors.black.withOpacity(0.5),
          //             width: double.infinity,
          //             height: double.infinity,
          //           ),
          //         ),
          //         Center(child: LoginPopup()),
          //       ],
          //     );
          //   }

          //   return const SizedBox.shrink();
          // }),
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
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
      height: 200, // adjust height
      child: Obx(() {
        final banners = widget.data.banners;
        if (banners.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: controller.pageController,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return Image.network(
              banner['image_url'] ?? '',
              fit: BoxFit.cover,
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
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.data.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.5,
            ),
            itemBuilder: (context, index) {
              final category = widget.data.categories[index];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.parse(category['gradient_start'])),
                      Color(int.parse(category['gradient_end'])),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      category['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.data.featuredProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = widget.data.featuredProducts[index];

              return Container(
                width: 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.agriculture,
                      size: 40,
                      color: Colors.greenAccent,
                    ),
                    Text(
                      product['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Rs. ${product['price']}",
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
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
        return Column(
          children: widget.data.marketRates.map((rate) {
            return ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.white),
              title: Text(
                rate['crop_name'],
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text(
                "Rs. ${rate['price']}",
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
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
            double scale = 1.0;

            return StatefulBuilder(
              builder: (context, setState) {
                return GestureDetector(
                  onTapDown: (_) => setState(() => scale = 0.97),
                  onTapUp: (_) => setState(() => scale = 1.0),
                  onTapCancel: () => setState(() => scale = 1.0),
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Container(
                      width: 250,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            // ignore: deprecated_member_use
                            Colors.green.shade400.withOpacity(0.85),
                            // ignore: deprecated_member_use
                            Colors.green.shade200.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: Colors.white70,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                testimonials[index]['text']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "- ${testimonials[index]['name']!}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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
        if (widget.data.blogs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.data.blogs.length,
            itemBuilder: (context, index) {
              final blog = widget.data.blogs[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      // ignore: deprecated_member_use
                      Colors.green.shade400.withOpacity(0.8),
                      // ignore: deprecated_member_use
                      Colors.green.shade200.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail Image
                      blog['image_url'] != null && blog['image_url'].isNotEmpty
                          ? Image.network(
                              blog['image_url'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 100,
                              color: Colors.green.shade100,
                              child: const Icon(
                                Icons.article,
                                size: 40,
                                color: Colors.white70,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          blog['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

  Widget _farmerBenefits() => const SizedBox();

  Widget _sectionWrapper({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
