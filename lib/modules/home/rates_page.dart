// ─── rates_page.dart — UI Layer (pure widgets, zero data logic) ───────────────

import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/modules/home/rate_logic.dart';
import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════════════════════
// Page
// ═════════════════════════════════════════════════════════════════════════════
class RatesPage extends StatefulWidget {
  const RatesPage({super.key});

  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> {
  String _selectedMandi = RatesData.mandis.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderView(pageTitle: 'Market Rates', cartCount: 0, ordersCount: 0),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: kGreenMint,
      body: Stack(
        children: [
          _buildBody(),
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(
            selectedMandi: _selectedMandi,
            onMandiChanged: (v) => setState(() => _selectedMandi = v!),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 120),
          sliver: SliverList.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemCount: RatesData.featured.length + 1, // +1 for section label
            itemBuilder: (context, i) {
              if (i == 0) return const _SectionLabel(text: 'Featured Crops');
              return _CropCard(crop: RatesData.featured[i - 1]);
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Header
// ═══════════════════════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final String selectedMandi;
  final ValueChanged<String?> onMandiChanged;

  const _Header({required this.selectedMandi, required this.onMandiChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreenDark, kGreenPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LiveBadge(),
          const SizedBox(height: 16),
          const Text(
            'Market Rates',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.2),
          ),
          const SizedBox(height: 2),
          const Text(
            "Today's commodity prices",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 18),
          _MandiDropdown(selected: selectedMandi, onChanged: onMandiChanged),
          const SizedBox(height: 16),
          _MarketSummaryRow(),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(color: Color(0xFF69F0AE), shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        const Text('LIVE', style: TextStyle(color: Color(0xFF69F0AE), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        const Spacer(),
        const Icon(Icons.access_time_rounded, color: Colors.white38, size: 12),
        const SizedBox(width: 4),
        Text(
          'Updated ${RatesData.lastUpdated}',
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}

class _MandiDropdown extends StatelessWidget {
  final String selected;
  final ValueChanged<String?> onChanged;

  const _MandiDropdown({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          dropdownColor: kGreenDark,
          iconEnabledColor: Colors.white60,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          items: RatesData.mandis.map((m) => DropdownMenuItem(
            value: m,
            child: Row(children: [
              const Icon(Icons.storefront_outlined, color: Colors.white60, size: 14),
              const SizedBox(width: 8),
              Text(m),
            ]),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _MarketSummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = RatesData.marketSummary;
    return Row(
      children: [
        _SummaryChip(icon: Icons.trending_up, label: '${s.up} Up', color: const Color(0xFF69F0AE)),
        const SizedBox(width: 8),
        _SummaryChip(icon: Icons.trending_down, label: '${s.down} Down', color: const Color(0xFFFF7043)),
        const SizedBox(width: 8),
        _SummaryChip(icon: Icons.horizontal_rule, label: '${s.stable} Stable', color: Colors.white54),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SummaryChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section Label
// ═══════════════════════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 4, height: 20,
            decoration: BoxDecoration(color: kGreenPrimary, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Crop Rate Card
// ═══════════════════════════════════════════════════════════════════════════════
class _CropCard extends StatelessWidget {
  final CropRate crop;
  const _CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGreenBorder),
        boxShadow: [
          BoxShadow(color: kGreenPrimary.withOpacity(0.07), blurRadius: 14, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _CardTop(crop: crop),
          _CardBottom(crop: crop),
        ],
      ),
    );
  }
}

class _CardTop extends StatelessWidget {
  final CropRate crop;
  const _CardTop({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          // Emoji icon
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: kGreenPale, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(crop.emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          // Name + MSP badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 5),
                _MspBadge(aboveMsp: crop.aboveMsp, msp: crop.msp),
              ],
            ),
          ),
          // Rate
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                crop.rate,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(crop.unit, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBottom extends StatelessWidget {
  final CropRate crop;
  const _CardBottom({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(color: crop.trendBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Change
          Row(children: [
            Icon(
              crop.isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: crop.trendColor, size: 15,
            ),
            const SizedBox(width: 3),
            Text(crop.change,
                style: TextStyle(color: crop.trendColor, fontWeight: FontWeight.bold, fontSize: 13)),
            Text('  today',
                style: TextStyle(color: crop.trendColor.withOpacity(0.6), fontSize: 11)),
          ]),
          // High / Low
          _HighLow(label: 'H', value: crop.high, color: kGreenPrimary),
          _HighLow(label: 'L', value: crop.low, color: kRedAlert),

          // ✅ Bottom Right Widgets (Proper Alignment)
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}

// ─── Small reusable atoms ─────────────────────────────────────────────────────
class _MspBadge extends StatelessWidget {
  final bool? aboveMsp;
  final String msp;
  const _MspBadge({this.aboveMsp, required this.msp});

  @override
  Widget build(BuildContext context) {
    if (aboveMsp == null) {
      return Text('No MSP', style: const TextStyle(color: Colors.grey, fontSize: 11));
    }
    final color = aboveMsp! ? kGreenPrimary : kRedAlert;
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(5)),
        child: Text(
          aboveMsp! ? 'Above MSP' : 'Below MSP',
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(width: 6),
      Text('MSP $msp', style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ]);
  }
}

class _HighLow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _HighLow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
      const SizedBox(width: 4),
      Text(value, style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w500)),
    ]);
  }
}