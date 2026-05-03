import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:flutter/material.dart';

// ─── Green Color Palette ──────────────────────────────────────────────────────
const Color kGreenPrimary   = Color(0xFF2E7D32);
const Color kGreenDark      = Color(0xFF1B5E20);
const Color kGreenMedium    = Color(0xFF388E3C);
const Color kGreenLight     = Color(0xFF66BB6A);
const Color kGreenPale      = Color(0xFFE8F5E9);
const Color kGreenAccent    = Color(0xFFA5D6A7);
const Color kGreenMint      = Color(0xFFF1F8E9);
const Color kGreenBorder    = Color(0xFFC8E6C9);

// ─── Crop Page ────────────────────────────────────────────────────────────────
class CropPage extends StatefulWidget {
  const CropPage({super.key});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  int _selectedSeasonIndex = 0;
  final List<String> _seasons = ['All', 'Kharif', 'Rabi', 'Zaid'];

  final List<Map<String, dynamic>> _myCrops = [
    {
      'name': 'Wheat',
      'area': '5 Acres',
      'status': 'Growing',
      'health': 0.85,
      'daysLeft': 32,
      'season': 'Rabi',
      'color': Color(0xFF8BC34A),
      'icon': '🌾',
    },
    {
      'name': 'Rice',
      'area': '3 Acres',
      'status': 'Harvesting',
      'health': 0.92,
      'daysLeft': 8,
      'season': 'Kharif',
      'color': Color(0xFF4CAF50),
      'icon': '🌿',
    },
    {
      'name': 'Sugarcane',
      'area': '2 Acres',
      'status': 'Sowing',
      'health': 0.70,
      'daysLeft': 90,
      'season': 'Zaid',
      'color': Color(0xFF66BB6A),
      'icon': '🌱',
    },
    {
      'name': 'Maize',
      'area': '4 Acres',
      'status': 'Growing',
      'health': 0.78,
      'daysLeft': 45,
      'season': 'Kharif',
      'color': Color(0xFFFFA726),
      'icon': '🌽',
    },
  ];

  final List<Map<String, dynamic>> _advisories = [
    {
      'type': 'Pest Alert',
      'crop': 'Wheat',
      'message': 'Aphid activity detected in your region',
      'severity': 'High',
      'icon': Icons.bug_report_outlined,
      'color': Color(0xFFD32F2F),
    },
    {
      'type': 'Weather',
      'crop': 'All Crops',
      'message': 'Light rain expected over next 3 days',
      'severity': 'Info',
      'icon': Icons.water_drop_outlined,
      'color': Color(0xFF1976D2),
    },
    {
      'type': 'Fertilizer',
      'crop': 'Rice',
      'message': 'Apply nitrogen fertilizer within 5 days',
      'severity': 'Medium',
      'icon': Icons.science_outlined,
      'color': Color(0xFFF57C00),
    },
  ];

  final List<Map<String, dynamic>> _buyListings = [
    {'crop': 'Wheat Seeds', 'variety': 'HD-3086', 'price': '₹ 85/kg', 'seller': 'AgriStore'},
    {'crop': 'Rice Seeds', 'variety': 'Basmati 370', 'price': '₹ 120/kg', 'seller': 'Kisan Hub'},
    {'crop': 'Maize Seeds', 'variety': 'DKC-9141', 'price': '₹ 250/kg', 'seller': 'FarmSupply'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: 'Crop',
        cartCount: 2,
        ordersCount: 1,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: kGreenMint,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(),
                _buildQuickActions(context),
                _buildSeasonFilter(),
                _buildMyCrops(),
                _buildAdvisorySection(),
                _buildBuySellSection(context),
                _buildYieldEstimation(),
              ],
            ),
          ),
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
  // ── Summary Cards ─────────────────────────────────────────────────────────
  Widget _buildSummaryCards() {
    final cards = [
      {'label': 'Total Crops', 'value': '4', 'icon': Icons.grass},
      {'label': 'Total Area', 'value': '14 Ac', 'icon': Icons.crop_square},
      {'label': 'Harvesting', 'value': '1', 'icon': Icons.agriculture},
      {'label': 'Avg. Health', 'value': '82%', 'icon': Icons.favorite_border},
    ];
    return Container(
      color: kGreenPrimary,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Farm Overview',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: cards.map((c) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      Icon(c['icon'] as IconData, color: Colors.white, size: 22),
                      const SizedBox(height: 6),
                      Text(
                        c['value'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Add Crop', 'icon': Icons.add_circle_outline, 'color': kGreenPrimary},
      {'label': 'Schedule', 'icon': Icons.calendar_month_outlined, 'color': Color(0xFF00897B)},
      {'label': 'Buy Seeds', 'icon': Icons.shopping_bag_outlined, 'color': Color(0xFF558B2F)},
      {'label': 'Pest Alert', 'icon': Icons.bug_report_outlined, 'color': Color(0xFFD84315)},
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((a) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (a['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 24),
                ),
                const SizedBox(height: 6),
                Text(a['label'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.black87)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Season Filter ─────────────────────────────────────────────────────────
  Widget _buildSeasonFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(_seasons.length, (i) {
          final selected = _selectedSeasonIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedSeasonIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? kGreenPrimary : kGreenPale,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? kGreenPrimary : kGreenBorder),
              ),
              child: Text(
                _seasons[i],
                style: TextStyle(
                  color: selected ? Colors.white : kGreenDark,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── My Crops ──────────────────────────────────────────────────────────────
  Widget _buildMyCrops() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('My Crops', 'See All'),
          const SizedBox(height: 12),
          ..._myCrops.map((crop) => _cropCard(crop)),
        ],
      ),
    );
  }

  Widget _cropCard(Map<String, dynamic> crop) {
    Color statusColor;
    switch (crop['status']) {
      case 'Harvesting': statusColor = kGreenPrimary; break;
      case 'Growing':    statusColor = Color(0xFF00897B); break;
      default:           statusColor = Color(0xFFF57C00);
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGreenBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kGreenPale,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(crop['icon'] as String, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            crop['name'] as String,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              crop['status'] as String,
                              style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${crop['area']}  •  ${crop['season']}  •  ${crop['daysLeft']} days left',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: kGreenLight),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Health', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: crop['health'] as double,
                      backgroundColor: kGreenBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(kGreenMedium),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${((crop['health'] as double) * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Advisory Section ──────────────────────────────────────────────────────
  Widget _buildAdvisorySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Advisories & Alerts', 'View All'),
          const SizedBox(height: 12),
          ..._advisories.map((adv) => _advisoryCard(adv)),
        ],
      ),
    );
  }

  Widget _advisoryCard(Map<String, dynamic> adv) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGreenBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (adv['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(adv['icon'] as IconData, color: adv['color'] as Color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(adv['type'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(width: 6),
                    Text('• ${adv['crop']}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(adv['message'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (adv['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(adv['severity'] as String,
                style: TextStyle(color: adv['color'] as Color, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Buy/Sell Section ──────────────────────────────────────────────────────
  Widget _buildBuySellSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Buy Seeds & Inputs', 'Browse All'),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _buyListings.length,
              itemBuilder: (context, i) {
                final item = _buyListings[i];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kGreenBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: kGreenPale,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: Icon(Icons.grass, color: kGreenPrimary, size: 28)),
                      ),
                      const SizedBox(height: 8),
                      Text(item['crop'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                      Text(item['variety'] as String,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const Spacer(),
                      Text(item['price'] as String,
                          style: const TextStyle(color: kGreenPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sell_outlined, color: kGreenPrimary),
              label: const Text('List My Crop for Sale', style: TextStyle(color: kGreenPrimary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kGreenPrimary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Yield Estimation ──────────────────────────────────────────────────────
  Widget _buildYieldEstimation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kGreenPrimary, kGreenMedium],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Estimated Yield This Season',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _YieldItem(crop: 'Wheat', yield: '18 Qt/Ac', trend: '+12%'),
                _YieldItem(crop: 'Rice', yield: '22 Qt/Ac', trend: '+8%'),
                _YieldItem(crop: 'Maize', yield: '14 Qt/Ac', trend: '+5%'),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Colors.white30),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('View Detailed Yield Report',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('View →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        GestureDetector(
          onTap: () {},
          child: Text(action, style: const TextStyle(color: kGreenPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ── Yield Item Widget ─────────────────────────────────────────────────────────
class _YieldItem extends StatelessWidget {
  final String crop;
  final String yield;
  final String trend;
  const _YieldItem({required this.crop, required this.yield, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(crop, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(yield, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(trend, style: const TextStyle(color: Color(0xFFB9F6CA), fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}