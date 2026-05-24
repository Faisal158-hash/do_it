import 'package:do_it/common/date_time_widget.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/modules/home/equipment_logic.dart';
import 'package:flutter/material.dart';

// ─── Equipment List Page ──────────────────────────────────────────────────────
class EquipmentListPage extends StatefulWidget {
  const EquipmentListPage({super.key});

  @override
  State<EquipmentListPage> createState() => _EquipmentListPageState();
}

class _EquipmentListPageState extends State<EquipmentListPage> {
  int _selectedTypeIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Equipment> get _filtered {
    final byType = EquipmentRepository.byType(
      EquipmentRepository.types[_selectedTypeIndex],
    );
    if (_searchQuery.isEmpty) return byType;
    return byType
        .where((e) =>
            e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            e.location.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenMint,
      body: Column(
        children: [
          _Header(
            controller: _searchController,
            onSearch: (q) => setState(() => _searchQuery = q),
            totalCount: EquipmentRepository.all.length,
          ),
          _TypeFilterBar(
            types: EquipmentRepository.types,
            selectedIndex: _selectedTypeIndex,
            onSelect: (i) => setState(() => _selectedTypeIndex = i),
          ),
          Expanded(
            child: _EquipmentListView(items: _filtered),
          ),
          // ✅ Bottom Right Widgets (Proper Alignment)
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final int totalCount;

  const _Header({
    required this.controller,
    required this.onSearch,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreenDark, Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Farm Equipment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              _HeaderBadge(label: '$totalCount Items'),
            ],
          ),
          const SizedBox(height: 14),

          // Search bar
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search tractors, tools, sprayers…',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: kGreenPrimary,
                  size: 20,
                ),
                suffixIcon: Icon(
                  Icons.tune_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Stat pills
          Wrap(
            spacing: 8,
            children: const [
              _StatPill(Icons.check_circle_outline_rounded, '18 Available'),
              _StatPill(Icons.location_on_outlined, '12 km radius'),
              _StatPill(Icons.handshake_outlined, 'Rent & Buy'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final String label;
  const _HeaderBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatPill(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─── Type Filter Bar ──────────────────────────────────────────────────────────
class _TypeFilterBar extends StatelessWidget {
  final List<String> types;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _TypeFilterBar({
    required this.types,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: types.length,
        itemBuilder: (_, i) {
          final selected = selectedIndex == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? kGreenPrimary : kGreenPale,
                borderRadius: BorderRadius.circular(20),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: kGreenPrimary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Text(
                types[i],
                style: TextStyle(
                  color: selected ? Colors.white : kGreenDark,
                  fontSize: 12.5,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Equipment List View ──────────────────────────────────────────────────────
class _EquipmentListView extends StatelessWidget {
  final List<Equipment> items;
  const _EquipmentListView({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 42)),
            const SizedBox(height: 12),
            Text(
              'No equipment found',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: items.length,
      itemBuilder: (_, i) => _EquipmentCard(equipment: items[i]),
    );
  }
}

// ─── Equipment Card ───────────────────────────────────────────────────────────
class _EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  const _EquipmentCard({required this.equipment});

  @override
  Widget build(BuildContext context) {
    final e = equipment;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGreenBorder),
        boxShadow: [
          BoxShadow(
            color: kGreenPrimary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Emoji thumbnail ──
            _EmojiThumb(emoji: e.emoji, available: e.available),
            const SizedBox(width: 13),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + condition badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          e.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _ConditionBadge(
                        label: e.condition,
                        color: e.conditionColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Type · spec · year
                  Text(
                    '${e.type}  ·  ${e.spec}  ·  ${e.year}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Location + rating
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 2),
                      Text(
                        e.location,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11.5),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star_rounded,
                          size: 13, color: Color(0xFFFFA726)),
                      const SizedBox(width: 2),
                      Text(
                        '${e.rating}  (${e.reviews})',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),

                  // Divider
                  Divider(
                      color: kGreenBorder, thickness: 1, height: 1),
                  const SizedBox(height: 9),

                  // Price + CTA
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.price,
                            style: const TextStyle(
                              color: kGreenPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: kGreenPale,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              e.priceLabel,
                              style: const TextStyle(
                                color: kGreenDark,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _CtaButton(available: e.available),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Emoji Thumbnail ──────────────────────────────────────────────────────────
class _EmojiThumb extends StatelessWidget {
  final String emoji;
  final bool available;
  const _EmojiThumb({required this.emoji, required this.available});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: kGreenPale,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kGreenBorder),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 30)),
          ),
        ),
        if (!available)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.48),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'BOOKED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Condition Badge ──────────────────────────────────────────────────────────
class _ConditionBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _ConditionBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── CTA Button ───────────────────────────────────────────────────────────────
class _CtaButton extends StatelessWidget {
  final bool available;
  const _CtaButton({required this.available});

  @override
  Widget build(BuildContext context) {
    if (available) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF388E3C), kGreenPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: kGreenPrimary.withOpacity(0.30),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        'Unavailable',
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}