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

    // WELCOME POPUP
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showDialog(
          // ignore: use_build_context_synchronously
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

    //  AUTO SLIDER
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
  // ---------------- CATEGORIES ----------------
Widget _categories() {
  final routes = {
    'Market': MarketPage(),
    'Crops': CropPage(),
    'Equipment': EquipmentListPage(),
    'Rates': RatesPage(),
  };

  final categoryMeta = {
    'Market': _CategoryMeta(
      icon: Icons.storefront_rounded,
      gradientStart: const Color(0xFF2E7D32),
      gradientEnd: const Color(0xFF66BB6A),
      accent: const Color(0xFFA5D6A7),
      label: 'Buy & Sell',
    ),
    'Crops': _CategoryMeta(
      icon: Icons.grass_rounded,
      gradientStart: const Color(0xFF558B2F),
      gradientEnd: const Color(0xFF9CCC65),
      accent: const Color(0xFFCCFF90),
      label: 'Your Farm',
    ),
    'Equipment': _CategoryMeta(
      icon: Icons.agriculture_rounded,
      gradientStart: const Color(0xFF1B5E20),
      gradientEnd: const Color(0xFF43A047),
      accent: const Color(0xFFB9F6CA),
      label: 'Tools & Gear',
    ),
    'Rates': _CategoryMeta(
      icon: Icons.trending_up_rounded,
      gradientStart: const Color(0xFF33691E),
      gradientEnd: const Color(0xFF7CB342),
      accent: const Color(0xFFCCFF90),
      label: 'Live Prices',
    ),
  };

  return Obx(() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: homeController.categories.length,
        itemBuilder: (context, index) {
          final c = homeController.categories[index];
          final title = c['title'] ?? '';
          final meta = categoryMeta[title] ??
              _CategoryMeta(
                icon: Icons.category_rounded,
                gradientStart: const Color(0xFF2E7D32),
                gradientEnd: const Color(0xFF66BB6A),
                accent: const Color(0xFFA5D6A7),
                label: '',
              );

          return _AnimatedCategoryCard(
            title: title,
            meta: meta,
            onTap: () {
              if (routes.containsKey(title)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => routes[title]!),
                );
              }
            },
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
        "text": "Kisan Traders helped me sell crops at better prices.",
        "role": "Wheat Grower",
        "rating": 5,
      },
      {
        "name": "Farmer Sana",
        "text": "I got real-time market rates and sold my wheat profitably.",
        "role": "Rice Farmer",
        "rating": 5,
      },
      {
        "name": "Farmer Bilal",
        "text": "The platform is easy to use and very reliable.",
        "role": "Vegetable Grower",
        "rating": 4,
      },
    ];

    final isMobile = constraints.maxWidth < 600;
    final cardWidth = isMobile ? 260.0 : 310.0;
    final cardHeight = isMobile ? 210.0 : 230.0;

    return _sectionWrapper(
      title: 'Success Stories',
      child: SizedBox(
        height: cardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: testimonials.length,
          itemBuilder: (context, index) {
            return _TestimonialCard(
              testimonial: testimonials[index],
              width: cardWidth,
              height: cardHeight,
              index: index,
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

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      //  NAVIGATION LOGIC
                  
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

  // ─────────────────────────────────────────────
// Data model for category visual metadata
// ─────────────────────────────────────────────
class _CategoryMeta {
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final Color accent;
  final String label;

  const _CategoryMeta({
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.accent,
    required this.label,
  });
}

// ─────────────────────────────────────────────
// Animated card with press scale + shimmer dot
// ─────────────────────────────────────────────
class _AnimatedCategoryCard extends StatefulWidget {
  final String title;
  final _CategoryMeta meta;
  final VoidCallback onTap;

  const _AnimatedCategoryCard({
    required this.title,
    required this.meta,
    required this.onTap,
  });

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

// -------- Testimonial Card Widget (place outside main class or as inner class) --------
class _TestimonialCard extends StatefulWidget {
  final Map<String, dynamic> testimonial;
  final double width;
  final double height;
  final int index;

  const _TestimonialCard({
    required this.testimonial,
    required this.width,
    required this.height,
    required this.index,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard>
    with TickerProviderStateMixin {          // ← TickerProviderStateMixin (was Single...)

  // ── Controller 1: one-shot entrance fade+slide ──
  late AnimationController _entranceCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  // ── Controller 2: hover scale only ──
  late AnimationController _hoverCtrl;
  late Animation<double>   _scaleAnim;

  bool _isHovered = false;

  static const List<List<Color>> _gradients = [
    [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    [Color(0xFF388E3C), Color(0xFF81C784)],
    [Color(0xFF1B5E20), Color(0xFF43A047)],
  ];

  @override
  void initState() {
    super.initState();

    // ── Entrance: fade + slide up, plays once ──
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),   // starts slightly below
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut));

    // staggered entrance — card stays visible afterwards
    Future.delayed(Duration(milliseconds: 140 * widget.index), () {
      if (mounted) _entranceCtrl.forward();
    });

    // ── Hover: scale only, toggles back and forth ──
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _hoverCtrl.dispose();
    super.dispose();
  }

  void _onHoverChange(bool hovering) {
    setState(() => _isHovered = hovering);
    // only drives scale — fade is untouched
    hovering ? _hoverCtrl.forward() : _hoverCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _gradients[widget.index % _gradients.length];
    final int rating = widget.testimonial['rating'] as int;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: MouseRegion(
            onEnter: (_) => _onHoverChange(true),
            onExit:  (_) => _onHoverChange(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width:  widget.width,
              height: widget.height,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end:   Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:     gradient[0].withOpacity(_isHovered ? 0.55 : 0.28),
                    blurRadius: _isHovered ? 22 : 10,
                    offset:    const Offset(0, 6),
                  ),
                ],
              ),
              // ── everything inside stays exactly the same ──
              child: Stack(
                children: [
                  Positioned(
                    top: -6, right: 12,
                    child: Text(
                      '\u201C',
                      style: TextStyle(
                        fontSize: 90, height: 1,
                        color: Colors.white.withOpacity(0.12),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: RadialGradient(
                          center: Alignment.topLeft, radius: 1.2,
                          colors: [
                            Colors.white.withOpacity(0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: i < rating ? Colors.amber.shade300 : Colors.white30,
                            size: 16,
                          )),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            widget.testimonial['text'] as String,
                            style: const TextStyle(
                              color: Colors.white, fontSize: 13.5,
                              height: 1.55, letterSpacing: 0.2,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.white.withOpacity(0.25), thickness: 0.8),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white.withOpacity(0.20),
                              child: Text(
                                (widget.testimonial['name'] as String).split(' ').last[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.testimonial['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  )),
                                Text(widget.testimonial['role'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.72),
                                    fontSize: 11,
                                  )),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.verified_rounded, color: Colors.white, size: 11),
                                  SizedBox(width: 3),
                                  Text('Verified', style: TextStyle(color: Colors.white, fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            );
          },
          child: Container(
            width: 148,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  widget.meta.gradientStart,
                  widget.meta.gradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.meta.gradientStart.withOpacity(0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: widget.meta.gradientEnd.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                // ── Background decorative circle ──
                Positioned(
                  top: -18,
                  right: -18,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: -10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),

                // ── Main content ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon chip
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          widget.meta.icon,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),

                      // Titles
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          if (widget.meta.label.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.meta.label,
                              style: TextStyle(
                                color: widget.meta.accent.withOpacity(0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Shimmer top-right dot ──
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.meta.accent.withOpacity(0.75),
                      boxShadow: [
                        BoxShadow(
                          color: widget.meta.accent.withOpacity(0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
