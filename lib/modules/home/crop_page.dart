import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/modules/home/crop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
class _T {
  static const Color primary = Color(0xFF2E7D32);
  static const Color mid     = Color(0xFF43A047);
  static const Color light   = Color(0xFF81C784);
  static const Color pale    = Color(0xFFE8F5E9);
  static const Color bg      = Color(0xFFF4F7F4);
  static const Color card    = Colors.white;

  static const Color ink      = Color(0xFF0D1F0D);
  static const Color inkMid   = Color(0xFF3A5C3A);
  static const Color inkLight = Color(0xFF8FAA8B);

  static const List<Color> heroGrad = [Color(0xFF1B5E20), Color(0xFF2E7D32)];

  static const double rCard = 18.0;
}

// ─────────────────────────────────────────────────────────────────────────────
//  CROP PAGE
// ─────────────────────────────────────────────────────────────────────────────
class CropPage extends StatefulWidget {
  const CropPage({super.key});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  late final CropController _ctrl;
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.isRegistered<CropController>()
        ? Get.find<CropController>()
        : Get.put(CropController());
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _T.bg,
      appBar: const AppHeaderView(
        pageTitle: 'Crops',
        cartCount: 0,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _ctrl.loadCrops,
            color: _T.primary,
            displacement: 50,
            child: LayoutBuilder(
              builder: (ctx, constraints) => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _PremiumHero(
                      ctrl: _ctrl,
                      searchCtrl: _searchCtrl,
                      onAddTap: () => _showAddSheet(ctx),
                    ),
                  ),
                  Obx(() {
                    if (_ctrl.isLoading.value) {
                      return const SliverFillRemaining(child: _Loader());
                    }
                    if (_ctrl.errorMessage.isNotEmpty) {
                      return SliverFillRemaining(
                        child: _ErrorState(
                          msg: _ctrl.errorMessage.value,
                          onRetry: _ctrl.loadCrops,
                        ),
                      );
                    }
                    if (_ctrl.filteredCrops.isEmpty) {
                      return const SliverFillRemaining(child: _EmptyState());
                    }
                    return _PremiumCropList(
                      crops: _ctrl.filteredCrops,
                      constraints: constraints,
                      onTap: (c) => _showDetailSheet(ctx, c),
                    );
                  }),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

  void _showDetailSheet(BuildContext ctx, Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _PremiumDetailSheet(crop: crop),
    );
  }

  void _showAddSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _PremiumAddSheet(ctrl: _ctrl),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PREMIUM HERO  — title + search + filter tabs (counts shown ONLY here)
// ─────────────────────────────────────────────────────────────────────────────
class _PremiumHero extends StatelessWidget {
  final CropController ctrl;
  final TextEditingController searchCtrl;
  final VoidCallback onAddTap;

  const _PremiumHero({
    required this.ctrl,
    required this.searchCtrl,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: _T.heroGrad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          // decorative blobs
          Positioned(top: -50, right: -50, child: _blob(200, 0.06)),
          Positioned(bottom: 10, left: -40, child: _blob(130, 0.04)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title row + Add button ─────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.22)),
                        ),
                        child: const Center(
                          child: Text('🌾', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Crop Guide',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Seeds · Water · Growth · Timeline',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ── ADD button top-right ─────────────────────────
                      GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: _T.primary, size: 17),
                              const SizedBox(width: 5),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: _T.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Search bar ─────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.14),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: ctrl.setSearch,
                      style: const TextStyle(
                          fontSize: 14,
                          color: _T.ink,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Search crops, products…',
                        hintStyle: const TextStyle(
                            color: _T.inkLight, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: _T.mid, size: 21),
                        suffixIcon: Obx(() => ctrl.searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  searchCtrl.clear();
                                  ctrl.setSearch('');
                                },
                                child: const Icon(Icons.close_rounded,
                                    color: _T.inkLight, size: 18),
                              )
                            : const SizedBox.shrink()),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Filter tabs — counts live ONLY here ────────────────
                  Obx(
                    () => _FilterTabs(
                      active: ctrl.activeFilter.value,
                      totalCount: ctrl.totalCount,
                      rabiCount: ctrl.rabiCount,
                      kharifCount: ctrl.kharifCount,
                      onSelect: ctrl.setFilter,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILTER TABS
// ─────────────────────────────────────────────────────────────────────────────
class _FilterTabs extends StatelessWidget {
  final String active;
  final int totalCount, rabiCount, kharifCount;
  final void Function(String) onSelect;

  const _FilterTabs({
    required this.active,
    required this.totalCount,
    required this.rabiCount,
    required this.kharifCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          _tab('Total', '🌱', totalCount),
          _tab('Rabi', '🌾', rabiCount),
          _tab('Kharif', '☀️', kharifCount),
        ],
      ),
    );
  }

  Widget _tab(String label, String emoji, int count) {
    final bool sel = active == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: sel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: sel
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      color: sel ? _T.primary : Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      height: 1,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: sel
                          ? _T.primary
                          : Colors.white.withOpacity(0.72),
                      fontSize: 10.5,
                      fontWeight:
                          sel ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CROP LIST
// ─────────────────────────────────────────────────────────────────────────────
class _PremiumCropList extends StatelessWidget {
  final List<Map<String, dynamic>> crops;
  final BoxConstraints constraints;
  final void Function(Map<String, dynamic>) onTap;

  const _PremiumCropList({
    required this.crops,
    required this.constraints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = constraints.maxWidth < 600;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
          isMobile ? 14 : 24, 18, isMobile ? 14 : 24, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) =>
              _CropCard(crop: crops[i], index: i, onTap: onTap),
          childCount: crops.length,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PREMIUM COMPACT CROP CARD
// ─────────────────────────────────────────────────────────────────────────────
class _CropCard extends StatefulWidget {
  final Map<String, dynamic> crop;
  final int index;
  final void Function(Map<String, dynamic>) onTap;

  const _CropCard(
      {required this.crop, required this.index, required this.onTap});

  @override
  State<_CropCard> createState() => _CropCardState();
}

class _CropCardState extends State<_CropCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _slide = Tween<Offset>(
            begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 55 * widget.index),
        () { if (mounted) _ac.forward(); });
  }

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final Color gs = Color(
        int.tryParse(widget.crop['gradient_start'] ?? '') ?? 0xFF2E7D32);
    final Color ge = Color(
        int.tryParse(widget.crop['gradient_end'] ?? '') ?? 0xFF66BB6A);

    final String name    = widget.crop['name'] ?? '';
    final String season  = widget.crop['season'] ?? '';
    final int growthM    = widget.crop['growth_months'] ?? 0;
    final String seeds   = _fmt(widget.crop['seeds_per_acre_kg']);
    final int wFreq      = widget.crop['watering_frequency_days'] ?? 0;
    final int wCount     = widget.crop['watering_count_total'] ?? 0;
    final String products = widget.crop['products_needed'] ?? '';
    final String desc    = widget.crop['description'] ?? '';

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => widget.onTap(widget.crop),
            child: Container(
              decoration: BoxDecoration(
                color: _T.card,
                borderRadius: BorderRadius.circular(_T.rCard),
                boxShadow: [
                  BoxShadow(
                    color: gs.withOpacity(0.13),
                    blurRadius: 22,
                    offset: const Offset(0, 7),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_T.rCard),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Left colour strip ────────────────────────────
                      Container(
                        width: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [gs, ge],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -22, left: -22,
                              child: Container(
                                width: 88, height: 88,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.07),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0.18),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text('🌿',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$growthM',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'months',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      season,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Right content ────────────────────────────────
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              14, 13, 14, 13),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // name + arrow
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        color: _T.ink,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.4,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 26, height: 26,
                                    decoration: BoxDecoration(
                                      color: gs.withOpacity(0.09),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 11, color: gs),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                desc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: _T.inkLight,
                                    fontSize: 11.5,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 10),
                              // stat chips
                              Wrap(
                                spacing: 6,
                                runSpacing: 5,
                                children: [
                                  _chip(Icons.water_drop_rounded,
                                      '${wFreq}d', gs),
                                  _chip(Icons.opacity_rounded,
                                      '×$wCount', gs),
                                  _chip(Icons.grass_rounded,
                                      '${seeds}kg/ac', gs),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // product tags
                              Wrap(
                                spacing: 5,
                                runSpacing: 4,
                                children: products
                                    .split(',')
                                    .take(3)
                                    .where((p) => p.trim().isNotEmpty)
                                    .map((p) => _productTag(p.trim(), gs))
                                    .toList(),
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
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _productTag(String label, Color color) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: _T.pale,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 9.5,
                color: _T.inkMid,
                fontWeight: FontWeight.w600)),
      );

  String _fmt(dynamic v) {
    if (v == null) return '0';
    final d = (v as num).toDouble();
    return d % 1 == 0 ? d.toInt().toString() : d.toStringAsFixed(1);
  }
}

class _PremiumDetailSheet extends StatelessWidget {
  final Map<String, dynamic> crop;
  const _PremiumDetailSheet({required this.crop});

  @override
  Widget build(BuildContext context) {
    final Color gs = Color(int.tryParse(crop['gradient_start'] ?? '') ?? 0xFF2E7D32);
    final Color ge = Color(int.tryParse(crop['gradient_end'] ?? '') ?? 0xFF66BB6A);

    final List<String> products =
        (crop['products_needed'] ?? '').toString().split(',');

    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ───────── PREMIUM HEADER ─────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gs, ge],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Center(
                            child: Text('🌿', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            crop['name'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _badge('${crop['season']} Season'),
                        const SizedBox(width: 8),
                        _badge('${crop['growth_months']} Months'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔥 STATS ROW (KEPT FROM YOUR ORIGINAL)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _quickStat('⏱',
                              '${crop['growth_months'] ?? 0}m', 'Growth'),
                          _vDiv(),
                          _quickStat(
                              '🌱',
                              '${_fmt(crop['seeds_per_acre_kg'])}kg',
                              'Seeds/Ac'),
                          _vDiv(),
                          _quickStat(
                              '💧',
                              'Ev.${crop['watering_frequency_days'] ?? 0}d',
                              'Frequency'),
                          _vDiv(),
                          _quickStat(
                              '🚿',
                              '${crop['watering_count_total'] ?? 0}×',
                              'Irrigations'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ───────── BODY ─────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🔥 DESCRIPTION CARD
                    _card(
                      child: Text(
                        crop['description'] ?? '',
                        style: const TextStyle(
                          height: 1.6,
                          color: _T.inkMid,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    _sectionTitle('🧪 Required Products'),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: products
                          .where((p) => p.trim().isNotEmpty)
                          .map((p) => _chip(p.trim(), gs))
                          .toList(),
                    ),

                    const SizedBox(height: 26),

                    _sectionTitle('📅 Growth Timeline'),
                    const SizedBox(height: 14),

                    _card(
                      child: _PremiumTimeline(
                        months: crop['growth_months'] ?? 0,
                        colorA: gs,
                        colorB: ge,
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── HELPERS ─────────

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      );

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _T.ink,
        ),
      );

  Widget _chip(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      );

  Widget _quickStat(String emoji, String val, String lbl) => Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 3),
          Text(val,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          Text(lbl,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 9.5)),
        ],
      );

  Widget _vDiv() => Container(
      width: 1, height: 34, color: Colors.white.withOpacity(0.2));

  String _fmt(dynamic v) {
    if (v == null) return '0';
    final d = (v as num).toDouble();
    return d % 1 == 0 ? d.toInt().toString() : d.toStringAsFixed(1);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PREMIUM TIMELINE
// ─────────────────────────────────────────────────────────────────────────────
class _PremiumTimeline extends StatelessWidget {
  final int months;
  final Color colorA, colorB;

  const _PremiumTimeline(
      {required this.months,
      required this.colorA,
      required this.colorB});

  static const _stages = [
    {'e': '🌱', 'l': 'Sowing'},
    {'e': '🌿', 'l': 'Germination'},
    {'e': '🍃', 'l': 'Vegetative'},
    {'e': '🌸', 'l': 'Flowering'},
    {'e': '🌾', 'l': 'Harvest'},
  ];

  @override
  Widget build(BuildContext context) {
    if (months == 0) return const SizedBox.shrink();
    final double step = months / _stages.length;
    return SizedBox(
      height: 90,
      child: Row(
        children: List.generate(_stages.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    colorA.withOpacity(0.25),
                    colorB.withOpacity(0.25)
                  ]),
                ),
              ),
            );
          }
          final int idx = i ~/ 2;
          final int mm =
              ((idx + 1) * step).round().clamp(1, months);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_stages[idx]['e']!,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 5),
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorA, colorB],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: colorA.withOpacity(0.4),
                        blurRadius: 5)
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text('${mm}m',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colorA,
                  )),
              Text(_stages[idx]['l']!,
                  style: const TextStyle(
                      fontSize: 8.5, color: _T.inkLight)),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PREMIUM ADD SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _PremiumAddSheet extends StatefulWidget {
  final CropController ctrl;
  const _PremiumAddSheet({required this.ctrl});

  @override
  State<_PremiumAddSheet> createState() => _PremiumAddSheetState();
}

class _PremiumAddSheetState extends State<_PremiumAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _growthCtrl   = TextEditingController();
  final _seedsCtrl    = TextEditingController();
  final _waterFCtrl   = TextEditingController();
  final _waterCCtrl   = TextEditingController();
  final _productsCtrl = TextEditingController();
  final _descCtrl     = TextEditingController();
  String _season = 'Rabi';

  @override
  void dispose() {
    for (final c in [_nameCtrl, _growthCtrl, _seedsCtrl,
          _waterFCtrl, _waterCCtrl, _productsCtrl, _descCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await widget.ctrl.saveCrop(
      name: _nameCtrl.text.trim(),
      season: _season,
      growthMonths: int.tryParse(_growthCtrl.text.trim()) ?? 0,
      seedsPerAcre: double.tryParse(_seedsCtrl.text.trim()) ?? 0,
      waterFrequencyDays: int.tryParse(_waterFCtrl.text.trim()) ?? 0,
      waterCountTotal: int.tryParse(_waterCCtrl.text.trim()) ?? 0,
      productsNeeded: _productsCtrl.text.trim(),
      description: _descCtrl.text.trim(),
    );
    if (ok && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(22, 16, 22, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 38, height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // header
                Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: _T.heroGrad),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 13),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add New Crop',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: _T.ink,
                                letterSpacing: -0.3)),
                        Text('Fill in the crop details below',
                            style: TextStyle(
                                fontSize: 12,
                                color: _T.inkLight)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                _divider('Basic Info'),
                const SizedBox(height: 12),
                _field(_nameCtrl, 'Crop Name',
                    Icons.local_florist_rounded, required: true),

                // season toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _T.pale,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: ['Rabi', 'Kharif'].map((s) {
                      final bool sel = _season == s;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _season = s),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            decoration: BoxDecoration(
                              gradient: sel
                                  ? const LinearGradient(
                                      colors: _T.heroGrad)
                                  : null,
                              borderRadius:
                                  BorderRadius.circular(8),
                              boxShadow: sel
                                  ? [
                                      BoxShadow(
                                        color: _T.primary
                                            .withOpacity(0.25),
                                        blurRadius: 6,
                                        offset:
                                            const Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              s == 'Rabi'
                                  ? '🌾  Rabi'
                                  : '☀️  Kharif',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: sel
                                    ? Colors.white
                                    : _T.inkMid,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),
                _divider('Growing Details'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _field(_growthCtrl,
                            'Growth (months)',
                            Icons.calendar_month_rounded,
                            required: true,
                            isNumber: true)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _field(_seedsCtrl,
                            'Seeds/Acre (kg)',
                            Icons.science_outlined,
                            required: true,
                            isNumber: true)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: _field(_waterFCtrl,
                            'Water every (days)',
                            Icons.water_drop_rounded,
                            required: true,
                            isNumber: true)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _field(_waterCCtrl,
                            'Total Irrigations',
                            Icons.opacity_rounded,
                            required: true,
                            isNumber: true)),
                  ],
                ),

                const SizedBox(height: 4),
                _divider('Additional Info'),
                const SizedBox(height: 12),
                _field(_productsCtrl,
                    'Products (comma separated)',
                    Icons.science_rounded),
                _field(_descCtrl, 'Description',
                    Icons.description_rounded,
                    maxLines: 3),
                const SizedBox(height: 10),

                // save button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: widget.ctrl.isSaving.value
                            ? null
                            : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _T.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              _T.primary.withOpacity(0.45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16)),
                        ),
                        child: widget.ctrl.isSaving.value
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5))
                            : const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_rounded,
                                      size: 18),
                                  SizedBox(width: 8),
                                  Text('Save Crop',
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.w800,
                                          fontSize: 15,
                                          letterSpacing: 0.2)),
                                ],
                              ),
                      ),
                    )),
                    
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider(String label) => Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _T.inkLight,
                  letterSpacing: 0.5)),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: _T.pale)),
        ],
      );

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool required = false,
    bool isNumber = false,
    int maxLines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.text,
          validator: required
              ? (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null
              : null,
          style: const TextStyle(
              fontSize: 13.5,
              color: _T.ink,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                const TextStyle(fontSize: 13, color: _T.inkLight),
            prefixIcon: Icon(icon, color: _T.mid, size: 18),
            filled: true,
            fillColor: _T.pale,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: _T.light.withOpacity(0.25), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: _T.mid, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  STATE VIEWS
// ─────────────────────────────────────────────────────────────────────────────
class _Loader extends StatelessWidget {
  const _Loader();
  @override
  Widget build(BuildContext context) => const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(color: _T.primary, strokeWidth: 2.5),
          SizedBox(height: 14),
          Text('Loading crops…',
              style: TextStyle(color: _T.inkLight, fontSize: 14)),
        ]),
      );
}

class _ErrorState extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;
  const _ErrorState({required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                  color: Colors.red.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Colors.red, size: 34),
            ),
            const SizedBox(height: 16),
            Text(msg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _T.inkMid, fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _T.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
          ]),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('🌱', style: TextStyle(fontSize: 52)),
          SizedBox(height: 12),
          Text('No crops found',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800, color: _T.ink)),
          SizedBox(height: 6),
          Text('Try a different search or filter',
              style: TextStyle(fontSize: 13, color: _T.inkLight)),
        ]),
      );
}