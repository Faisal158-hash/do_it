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

// ─── Rates Page ────────────────────────────────────────────────────────────────
class RatesPage extends StatefulWidget {
  const RatesPage({super.key});

  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMandi = 'Lahore Mandi';

  final List<String> _mandis = [
    'Lahore Mandi',
    'Faisalabad Mandi',
    'Multan Mandi',
    'Gujranwala Mandi',
    'Rawalpindi Mandi',
  ];

  final List<Map<String, dynamic>> _liveRates = [
    {
      'crop': 'Wheat',
      'emoji': '🌾',
      'rate': '₹ 2,275',
      'unit': 'per Qt',
      'change': '+1.8%',
      'changeVal': 41.0,
      'isUp': true,
      'msp': '₹ 2,125',
      'aboveMsp': true,
      'high': '₹ 2,310',
      'low': '₹ 2,200',
    },
    {
      'crop': 'Basmati Rice',
      'emoji': '🍚',
      'rate': '₹ 4,520',
      'unit': 'per Qt',
      'change': '+0.4%',
      'changeVal': 18.0,
      'isUp': true,
      'msp': '₹ 4,000',
      'aboveMsp': true,
      'high': '₹ 4,600',
      'low': '₹ 4,460',
    },
    {
      'crop': 'Maize',
      'emoji': '🌽',
      'rate': '₹ 1,850',
      'unit': 'per Qt',
      'change': '-0.7%',
      'changeVal': -13.0,
      'isUp': false,
      'msp': '₹ 1,870',
      'aboveMsp': false,
      'high': '₹ 1,920',
      'low': '₹ 1,840',
    },
    {
      'crop': 'Sugarcane',
      'emoji': '🌿',
      'rate': '₹ 362',
      'unit': 'per Qt',
      'change': '+2.3%',
      'changeVal': 8.0,
      'isUp': true,
      'msp': '₹ 340',
      'aboveMsp': true,
      'high': '₹ 370',
      'low': '₹ 355',
    },
    {
      'crop': 'Cotton',
      'emoji': '🧶',
      'rate': '₹ 6,780',
      'unit': 'per Qt',
      'change': '-1.2%',
      'changeVal': -82.0,
      'isUp': false,
      'msp': '₹ 6,620',
      'aboveMsp': true,
      'high': '₹ 6,900',
      'low': '₹ 6,720',
    },
    {
      'crop': 'Onion',
      'emoji': '🧅',
      'rate': '₹ 820',
      'unit': 'per Qt',
      'change': '+5.1%',
      'changeVal': 40.0,
      'isUp': true,
      'msp': 'No MSP',
      'aboveMsp': null,
      'high': '₹ 880',
      'low': '₹ 780',
    },
    {
      'crop': 'Tomato',
      'emoji': '🍅',
      'rate': '₹ 38',
      'unit': 'per Kg',
      'change': '-3.8%',
      'changeVal': -1.5,
      'isUp': false,
      'msp': 'No MSP',
      'aboveMsp': null,
      'high': '₹ 45',
      'low': '₹ 35',
    },
    {
      'crop': 'Potato',
      'emoji': '🥔',
      'rate': '₹ 1,950',
      'unit': 'per Bag',
      'change': '+0.3%',
      'changeVal': 6.0,
      'isUp': true,
      'msp': 'No MSP',
      'aboveMsp': null,
      'high': '₹ 2,000',
      'low': '₹ 1,900',
    },
  ];

  final List<Map<String, dynamic>> _mspList = [
    {'crop': 'Wheat', 'emoji': '🌾', 'msp': '₹ 2,125/Qt', 'season': 'Rabi 2025-26', 'hike': '+5.0%', 'current': '₹ 2,275', 'aboveMsp': true},
    {'crop': 'Paddy (Common)', 'emoji': '🌾', 'msp': '₹ 2,183/Qt', 'season': 'Kharif 2025-26', 'hike': '+4.6%', 'current': '₹ 2,240', 'aboveMsp': true},
    {'crop': 'Paddy (Grade A)', 'emoji': '🍚', 'msp': '₹ 2,203/Qt', 'season': 'Kharif 2025-26', 'hike': '+4.5%', 'current': '₹ 2,290', 'aboveMsp': true},
    {'crop': 'Maize', 'emoji': '🌽', 'msp': '₹ 1,870/Qt', 'season': 'Kharif 2025-26', 'hike': '+6.2%', 'current': '₹ 1,850', 'aboveMsp': false},
    {'crop': 'Cotton (Long)', 'emoji': '🧶', 'msp': '₹ 6,620/Qt', 'season': 'Kharif 2025-26', 'hike': '+3.8%', 'current': '₹ 6,780', 'aboveMsp': true},
    {'crop': 'Sugarcane', 'emoji': '🌿', 'msp': '₹ 340/Qt', 'season': 'Season 2025-26', 'hike': '+8.0%', 'current': '₹ 362', 'aboveMsp': true},
  ];

  final List<Map<String, dynamic>> _myAlerts = [
    {'crop': 'Wheat', 'emoji': '🌾', 'target': '₹ 2,400/Qt', 'type': 'Sell Alert', 'active': true},
    {'crop': 'Tomato', 'emoji': '🍅', 'target': '₹ 50/Kg', 'type': 'Buy Alert', 'active': false},
    {'crop': 'Onion', 'emoji': '🧅', 'target': '₹ 1,000/Qt', 'type': 'Sell Alert', 'active': true},
  ];

  final List<Map<String, dynamic>> _mandiComparison = [
    {'mandi': 'Lahore', 'wheat': '₹ 2,275', 'rice': '₹ 4,520', 'maize': '₹ 1,850'},
    {'mandi': 'Faisalabad', 'wheat': '₹ 2,290', 'rice': '₹ 4,500', 'maize': '₹ 1,870'},
    {'mandi': 'Multan', 'wheat': '₹ 2,260', 'rice': '₹ 4,480', 'maize': '₹ 1,840'},
    {'mandi': 'Gujranwala', 'wheat': '₹ 2,305', 'rice': '₹ 4,560', 'maize': '₹ 1,880'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: 'Rates',
        cartCount: 0,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: kGreenMint,
      body: Stack(
        children: [
          Column(
            children: [
              _buildRatesHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLiveRatesTab(),
                    _buildMSPTab(),
                    _buildAlertsTab(),
                    _buildComparisonTab(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildRatesHeader() {
    return Container(
      color: kGreenPrimary,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: Color(0xFF69F0AE), size: 10),
              const SizedBox(width: 6),
              const Text('Live Market Rates', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              const Icon(Icons.access_time, color: Colors.white70, size: 13),
              const SizedBox(width: 4),
              Text(
                'Updated: ${TimeOfDay.now().format(context)}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mandi selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMandi,
                dropdownColor: kGreenDark,
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                items: _mandis.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(m, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedMandi = v);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Market summary row
          Row(
            children: [
              _headerChip(Icons.trending_up, '14 Up', const Color(0xFF69F0AE)),
              const SizedBox(width: 8),
              _headerChip(Icons.trending_down, '4 Down', const Color(0xFFFF7043)),
              const SizedBox(width: 8),
              _headerChip(Icons.horizontal_rule, '2 Stable', Colors.white70),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: kGreenPrimary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: kGreenPrimary,
        indicatorWeight: 3,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Live Rates'),
          Tab(text: 'MSP Tracker'),
          Tab(text: 'My Alerts'),
          Tab(text: 'Mandi Compare'),
        ],
      ),
    );
  }

  // ── Live Rates Tab ─────────────────────────────────────────────────────────
  Widget _buildLiveRatesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTickerBar(),
          _buildTopMoversStrip(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _sectionHeader('All Commodity Rates', ''),
                const SizedBox(height: 12),
                ..._liveRates.map((r) => _rateCard(r)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTickerBar() {
    return Container(
      height: 38,
      color: kGreenDark,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _liveRates.length,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('|', style: TextStyle(color: Colors.white30)),
        ),
        itemBuilder: (context, i) {
          final r = _liveRates[i];
          final isUp = r['isUp'] as bool;
          return Row(
            children: [
              Text('${r['emoji']} ${r['crop']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(width: 4),
              Text(r['rate'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(r['change'] as String,
                  style: TextStyle(
                    color: isUp ? const Color(0xFF69F0AE) : const Color(0xFFFF7043),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopMoversStrip() {
    final topMovers = _liveRates.where((r) => (r['changeVal'] as double).abs() > 5).toList();
    if (topMovers.isEmpty) return const SizedBox.shrink();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Movers Today',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topMovers.length,
              itemBuilder: (context, i) {
                final r = topMovers[i];
                final isUp = r['isUp'] as bool;
                return Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUp ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUp ? kGreenBorder : const Color(0xFFFFCDD2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(r['emoji'] as String, style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          Icon(
                            isUp ? Icons.trending_up : Icons.trending_down,
                            color: isUp ? kGreenPrimary : const Color(0xFFD32F2F),
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(r['crop'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text(r['change'] as String,
                          style: TextStyle(
                            color: isUp ? kGreenPrimary : const Color(0xFFD32F2F),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateCard(Map<String, dynamic> r) {
    final isUp = r['isUp'] as bool;
    final Color changeColor = isUp ? kGreenPrimary : const Color(0xFFD32F2F);
    final bool? aboveMsp = r['aboveMsp'] as bool?;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGreenBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text(r['emoji'] as String, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['crop'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (aboveMsp != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: (aboveMsp ? kGreenPrimary : const Color(0xFFD32F2F)).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                aboveMsp ? 'Above MSP' : 'Below MSP',
                                style: TextStyle(
                                  color: aboveMsp ? kGreenPrimary : const Color(0xFFD32F2F),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (aboveMsp != null) const SizedBox(width: 6),
                          Text('MSP: ${r['msp']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(r['rate'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(r['unit'] as String,
                        style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: changeColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward, color: changeColor, size: 14),
                      const SizedBox(width: 3),
                      Text(r['change'] as String,
                          style: TextStyle(color: changeColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(' today', style: TextStyle(color: changeColor.withOpacity(0.7), fontSize: 11)),
                    ],
                  ),
                  _rateRange('H', r['high'] as String, kGreenPrimary),
                  _rateRange('L', r['low'] as String, const Color(0xFFD32F2F)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateRange(String label, String val, Color color) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(width: 3),
        Text(val, style: const TextStyle(color: Colors.black87, fontSize: 11)),
      ],
    );
  }

  // ── MSP Tracker Tab ────────────────────────────────────────────────────────
  Widget _buildMSPTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMspBanner(),
          const SizedBox(height: 16),
          _sectionHeader('Government MSP 2025–26', ''),
          const SizedBox(height: 12),
          ..._mspList.map((m) => _mspCard(m)),
          const SizedBox(height: 16),
          _buildMspInfo(),
        ],
      ),
    );
  }

  Widget _buildMspBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Minimum Support Price', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 4),
                const Text('Govt. Guaranteed\nPrices 2025–26', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, height: 1.3)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('6 Crops Covered', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const Text('🏛️', style: TextStyle(fontSize: 50)),
        ],
      ),
    );
  }

  Widget _mspCard(Map<String, dynamic> m) {
    final bool aboveMsp = m['aboveMsp'] as bool;
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
          Text(m['emoji'] as String, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m['crop'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text('MSP: ${m['msp']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kGreenPale,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(m['hike'] as String,
                          style: const TextStyle(color: kGreenPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(m['season'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Current', style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
              Text(m['current'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (aboveMsp ? kGreenPrimary : const Color(0xFFD32F2F)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  aboveMsp ? '▲ Above' : '▼ Below',
                  style: TextStyle(
                    color: aboveMsp ? kGreenPrimary : const Color(0xFFD32F2F),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMspInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF1565C0), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'MSP is the minimum price guaranteed by the government for your crop. '
              'If market rates fall below MSP, you can sell directly to government procurement centers.',
              style: TextStyle(color: Color(0xFF1565C0), fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Alerts Tab ─────────────────────────────────────────────────────────────
  Widget _buildAlertsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddAlertCard(),
          const SizedBox(height: 20),
          _sectionHeader('My Price Alerts', '${_myAlerts.length} Active'),
          const SizedBox(height: 12),
          ..._myAlerts.map((a) => _alertCard(a)),
          const SizedBox(height: 16),
          _buildSeasonalTrends(),
        ],
      ),
    );
  }

  Widget _buildAddAlertCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kGreenPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Set Price Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Get notified when your crop reaches your target price.',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Select crop...', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Target price...', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_alert_outlined, color: kGreenPrimary, size: 18),
              label: const Text('Add Alert', style: TextStyle(color: kGreenPrimary, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertCard(Map<String, dynamic> a) {
    final active = a['active'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? kGreenBorder : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(a['emoji'] as String, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a['crop'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: kGreenPale,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(a['type'] as String,
                          style: const TextStyle(color: kGreenDark, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                    Text('Target: ${a['target']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: active,
            activeColor: kGreenPrimary,
            onChanged: (v) {
              setState(() => a['active'] = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalTrends() {
    final trends = [
      {'crop': 'Wheat', 'peak': 'Apr–May', 'low': 'Oct–Nov', 'advice': 'Sell after Apr harvest', 'emoji': '🌾'},
      {'crop': 'Rice', 'peak': 'Jan–Feb', 'low': 'Oct (post-harvest)', 'advice': 'Store 2–3 months', 'emoji': '🍚'},
      {'crop': 'Onion', 'peak': 'Jun–Sep', 'low': 'Feb–Mar', 'advice': 'Hold if possible', 'emoji': '🧅'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Seasonal Price Trends', 'Full Chart'),
        const SizedBox(height: 12),
        ...trends.map((t) {
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
                Text(t['emoji'] as String, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['crop'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _trendBadge('Peak: ${t['peak']}', kGreenPrimary),
                          const SizedBox(width: 6),
                          _trendBadge('Low: ${t['low']}', const Color(0xFFD32F2F)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('💡 ${t['advice']}',
                          style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _trendBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }

  // ── Comparison Tab ─────────────────────────────────────────────────────────
  Widget _buildComparisonTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComparisonHeader(),
          const SizedBox(height: 16),
          _buildComparisonTable(),
          const SizedBox(height: 20),
          _sectionHeader('Best Selling Location', ''),
          const SizedBox(height: 12),
          _buildBestMandiCards(),
        ],
      ),
    );
  }

  Widget _buildComparisonHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGreenPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.compare_arrows, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Compare Mandi Rates', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 3),
                Text('Find where to get the best price for your crop', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGreenBorder),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: const BoxDecoration(
              color: kGreenPrimary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Mandi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Wheat', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Rice', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text('Maize', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
            ),
          ),
          ..._mandiComparison.asMap().entries.map((entry) {
            final i = entry.key;
            final m = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: i.isEven ? kGreenMint : Colors.white,
                border: const Border(bottom: BorderSide(color: kGreenBorder, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(m['mandi'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                  ),
                  Expanded(
                    child: Text(m['wheat'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ),
                  Expanded(
                    child: Text(m['rice'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ),
                  Expanded(
                    child: Text(m['maize'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBestMandiCards() {
    final best = [
      {'crop': 'Wheat 🌾', 'mandi': 'Gujranwala Mandi', 'rate': '₹ 2,305/Qt', 'diff': '+₹ 30'},
      {'crop': 'Rice 🍚', 'mandi': 'Gujranwala Mandi', 'rate': '₹ 4,560/Qt', 'diff': '+₹ 40'},
      {'crop': 'Maize 🌽', 'mandi': 'Gujranwala Mandi', 'rate': '₹ 1,880/Qt', 'diff': '+₹ 30'},
    ];
    return Column(
      children: best.map((b) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b['crop'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: kGreenPrimary),
                        Text(b['mandi'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(b['rate'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                  Text(b['diff'] as String,
                      style: const TextStyle(color: kGreenPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        if (action.isNotEmpty)
          GestureDetector(
            onTap: () {},
            child: Text(action, style: const TextStyle(color: kGreenPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}