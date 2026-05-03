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

// ─── Market Page ──────────────────────────────────────────────────────────────
class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  final List<String> _categories = ['All', 'Grains', 'Vegetables', 'Fruits', 'Pulses', 'Spices'];

  final List<Map<String, dynamic>> _listings = [
    {
      'crop': 'Wheat',
      'quantity': '50 Quintal',
      'price': '₹ 2,200/Qt',
      'location': 'Lahore, PB',
      'seller': 'Raza Farms',
      'rating': 4.7,
      'badge': 'Fresh',
      'badgeColor': Color(0xFF2E7D32),
      'daysAgo': '2 days ago',
      'emoji': '🌾',
    },
    {
      'crop': 'Basmati Rice',
      'quantity': '30 Quintal',
      'price': '₹ 4,500/Qt',
      'location': 'Gujranwala, PB',
      'seller': 'Ali Agri Co.',
      'rating': 4.5,
      'badge': 'Organic',
      'badgeColor': Color(0xFF00897B),
      'daysAgo': '1 day ago',
      'emoji': '🍚',
    },
    {
      'crop': 'Tomatoes',
      'quantity': '200 Kg',
      'price': '₹ 35/Kg',
      'location': 'Faisalabad, PB',
      'seller': 'Khan Produce',
      'rating': 4.3,
      'badge': 'Urgent',
      'badgeColor': Color(0xFFD84315),
      'daysAgo': '3 hrs ago',
      'emoji': '🍅',
    },
    {
      'crop': 'Potatoes',
      'quantity': '80 Bags',
      'price': '₹ 1,800/Bag',
      'location': 'Sahiwal, PB',
      'seller': 'Malik Farm',
      'rating': 4.8,
      'badge': 'Grade A',
      'badgeColor': Color(0xFF5C6BC0),
      'daysAgo': '5 hrs ago',
      'emoji': '🥔',
    },
    {
      'crop': 'Onion',
      'quantity': '100 Quintal',
      'price': '₹ 800/Qt',
      'location': 'Multan, PB',
      'seller': 'Chaudhry Agri',
      'rating': 4.2,
      'badge': 'Bulk',
      'badgeColor': Color(0xFF7B1FA2),
      'daysAgo': '1 day ago',
      'emoji': '🧅',
    },
  ];

  final List<Map<String, dynamic>> _recentOrders = [
    {
      'id': '#ORD-1042',
      'crop': 'Wheat',
      'qty': '10 Qt',
      'total': '₹ 22,000',
      'status': 'Delivered',
      'statusColor': Color(0xFF2E7D32),
      'date': '28 Apr 2026',
    },
    {
      'id': '#ORD-1035',
      'crop': 'Rice',
      'qty': '5 Qt',
      'total': '₹ 22,500',
      'status': 'In Transit',
      'statusColor': Color(0xFFF57C00),
      'date': '25 Apr 2026',
    },
    {
      'id': '#ORD-1021',
      'crop': 'Tomatoes',
      'qty': '50 Kg',
      'total': '₹ 1,750',
      'status': 'Cancelled',
      'statusColor': Color(0xFFD32F2F),
      'date': '20 Apr 2026',
    },
  ];

  final List<Map<String, dynamic>> _demandInsights = [
    {'crop': 'Wheat', 'demand': 0.9, 'trend': 'High ↑', 'color': Color(0xFF2E7D32)},
    {'crop': 'Rice', 'demand': 0.75, 'trend': 'Stable →', 'color': Color(0xFF00897B)},
    {'crop': 'Tomatoes', 'demand': 0.6, 'trend': 'Medium →', 'color': Color(0xFFF57C00)},
    {'crop': 'Onion', 'demand': 0.45, 'trend': 'Low ↓', 'color': Color(0xFFD32F2F)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        pageTitle: 'Market',
        cartCount: 3,
        ordersCount: 2,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: kGreenMint,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: kGreenPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Post Listing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(),
              _buildMarketStats(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBuyTab(),
                    _buildOrdersTab(),
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

  // ── Search Bar ────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: kGreenPrimary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search crops, sellers, location...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white30),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Market Stats ──────────────────────────────────────────────────────────
  Widget _buildMarketStats() {
    final stats = [
      {'label': 'Active Listings', 'value': '284'},
      {'label': 'Buyers Online', 'value': '47'},
      {'label': 'Trades Today', 'value': '33'},
      {'label': 'My Listings', 'value': '6'},
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Column(
              children: [
                Text(
                  s['value']!,
                  style: const TextStyle(
                    color: kGreenPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(s['label']!, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: kGreenPrimary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: kGreenPrimary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Buy / Browse'),
          Tab(text: 'My Orders'),
        ],
      ),
    );
  }

  // ── Buy Tab ────────────────────────────────────────────────────────────────
  Widget _buildBuyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(),
          _buildFeaturedBanner(),
          _buildListingsSection(),
          _buildDemandInsights(),
        ],
      ),
    );
  }

  // ── Category Filter ───────────────────────────────────────────────────────
  Widget _buildCategoryFilter() {
    return Container(
      height: 48,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? kGreenPrimary : kGreenPale,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? kGreenPrimary : kGreenBorder),
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  color: selected ? Colors.white : kGreenDark,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Featured Banner ───────────────────────────────────────────────────────
  Widget _buildFeaturedBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 110,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kGreenDark, kGreenMedium],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Kharif Season Sale', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Best prices on rice, maize & cotton', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Explore Deals →', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const Text('🌾', style: TextStyle(fontSize: 52)),
        ],
      ),
    );
  }

  // ── Listings Section ──────────────────────────────────────────────────────
  Widget _buildListingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Available Listings', 'See All (284)'),
          const SizedBox(height: 12),
          ..._listings.map((l) => _listingCard(l)),
        ],
      ),
    );
  }

  Widget _listingCard(Map<String, dynamic> l) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kGreenBorder),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: kGreenPale, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(l['emoji'] as String, style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l['crop'] as String,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: (l['badgeColor'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(l['badge'] as String,
                                style: TextStyle(color: l['badgeColor'] as Color, fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${l['quantity']}  •  ${l['location']}  •  ${l['daysAgo']}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 13, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text(l['seller'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 13, color: Color(0xFFFFA726)),
                          Text('${l['rating']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l['price'] as String,
                        style: const TextStyle(color: kGreenPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kGreenPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Bid', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Demand Insights ───────────────────────────────────────────────────────
  Widget _buildDemandInsights() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Demand Insights', 'Full Report'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kGreenBorder),
            ),
            child: Column(
              children: _demandInsights.map((d) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(d['crop'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: d['demand'] as double,
                            backgroundColor: kGreenBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(d['color'] as Color),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 70,
                        child: Text(
                          d['trend'] as String,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: d['color'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Orders Tab ─────────────────────────────────────────────────────────────
  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummaryRow(),
            const SizedBox(height: 20),
            _sectionHeader('Order History', 'View All'),
            const SizedBox(height: 12),
            ..._recentOrders.map((o) => _orderCard(o)),
            const SizedBox(height: 16),
            _buildBuyerMatchSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryRow() {
    final items = [
      {'label': 'Total Orders', 'value': '24', 'color': kGreenPrimary},
      {'label': 'Completed', 'value': '20', 'color': Color(0xFF00897B)},
      {'label': 'Pending', 'value': '3', 'color': Color(0xFFF57C00)},
    ];
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (item['color'] as Color).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(item['value'] as String,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: item['color'] as Color)),
                const SizedBox(height: 3),
                Text(item['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _orderCard(Map<String, dynamic> o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                Text(o['id'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 4),
                Text('${o['crop']}  •  ${o['qty']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(o['date'] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(o['total'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: (o['statusColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(o['status'] as String,
                    style: TextStyle(color: o['statusColor'] as Color, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerMatchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kGreenPrimary, kGreenMedium]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Buyer Matching', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          const Text('Connect with verified buyers in your district looking for your crops.',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Find Buyers', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kGreenPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Post Crop', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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