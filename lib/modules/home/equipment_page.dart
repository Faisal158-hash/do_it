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

// ─── Equipment Page ────────────────────────────────────────────────────────────
class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedType = 0;

  final List<String> _types = ['All', 'Tractors', 'Sprayers', 'Harvesters', 'Tools', 'Irrigation'];

  final List<Map<String, dynamic>> _equipmentList = [
    {
      'name': 'John Deere 5310',
      'type': 'Tractor',
      'hp': '55 HP',
      'pricePerDay': '₹ 1,800/day',
      'priceType': 'Rent',
      'owner': 'Tariq Farms',
      'location': 'Lahore',
      'rating': 4.8,
      'available': true,
      'condition': 'Excellent',
      'conditionColor': Color(0xFF2E7D32),
      'year': '2021',
      'emoji': '🚜',
      'reviews': 34,
    },
    {
      'name': 'Mahindra 575 DI',
      'type': 'Tractor',
      'hp': '47 HP',
      'pricePerDay': '₹ 1,400/day',
      'priceType': 'Rent',
      'owner': 'Ali Brothers',
      'location': 'Gujranwala',
      'rating': 4.5,
      'available': true,
      'condition': 'Good',
      'conditionColor': Color(0xFF388E3C),
      'year': '2019',
      'emoji': '🚜',
      'reviews': 18,
    },
    {
      'name': 'Power Sprayer 20L',
      'type': 'Sprayer',
      'hp': '2 HP Motor',
      'pricePerDay': '₹ 400/day',
      'priceType': 'Rent',
      'owner': 'Seed Center',
      'location': 'Faisalabad',
      'rating': 4.3,
      'available': false,
      'condition': 'Good',
      'conditionColor': Color(0xFF388E3C),
      'year': '2022',
      'emoji': '💧',
      'reviews': 12,
    },
    {
      'name': 'Combine Harvester',
      'type': 'Harvester',
      'hp': '120 HP',
      'pricePerDay': '₹ 3,500/day',
      'priceType': 'Rent',
      'owner': 'Agri Rentals',
      'location': 'Sahiwal',
      'rating': 4.9,
      'available': true,
      'condition': 'Excellent',
      'conditionColor': Color(0xFF2E7D32),
      'year': '2023',
      'emoji': '🌾',
      'reviews': 56,
    },
    {
      'name': 'Rotavator 7ft',
      'type': 'Tool',
      'hp': 'PTO Driven',
      'pricePerDay': '₹ 900/day',
      'priceType': 'Rent',
      'owner': 'Farm Tools Co.',
      'location': 'Multan',
      'rating': 4.1,
      'available': true,
      'condition': 'Fair',
      'conditionColor': Color(0xFFF57C00),
      'year': '2018',
      'emoji': '⚙️',
      'reviews': 9,
    },
    {
      'name': 'Drip Irrigation Kit',
      'type': 'Irrigation',
      'hp': '1 Acre Kit',
      'pricePerDay': '₹ 85,000',
      'priceType': 'Buy',
      'owner': 'IrriTech',
      'location': 'Lahore',
      'rating': 4.6,
      'available': true,
      'condition': 'New',
      'conditionColor': Color(0xFF1976D2),
      'year': '2026',
      'emoji': '🌊',
      'reviews': 23,
    },
  ];

  final List<Map<String, dynamic>> _myEquipment = [
    {
      'name': 'Old Tractor MF-240',
      'status': 'Listed',
      'statusColor': Color(0xFF2E7D32),
      'bookings': 5,
      'earned': '₹ 12,500',
      'emoji': '🚜',
    },
    {
      'name': 'Water Pump 3HP',
      'status': 'Booked',
      'statusColor': Color(0xFFF57C00),
      'bookings': 2,
      'earned': '₹ 3,200',
      'emoji': '💧',
    },
  ];

  final List<Map<String, dynamic>> _repairServices = [
    {
      'name': 'Agri Repair Hub',
      'type': 'Tractor & Engine',
      'rating': 4.7,
      'distance': '3.2 km',
      'open': true,
    },
    {
      'name': 'Punjab Farm Services',
      'type': 'All Equipment',
      'rating': 4.5,
      'distance': '5.8 km',
      'open': true,
    },
    {
      'name': 'SprayTech Workshop',
      'type': 'Sprayers & Pumps',
      'rating': 4.2,
      'distance': '8.1 km',
      'open': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        pageTitle: 'Equipment',
        cartCount: 0,
        ordersCount: 1,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: kGreenMint,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: kGreenPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('List Equipment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildEquipmentHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRentBuyTab(),
                    _buildMyEquipmentTab(),
                    _buildRepairTab(),
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
  Widget _buildEquipmentHeader() {
    return Container(
      color: kGreenPrimary,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search tractors, tools, equipment...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statPill('86 Available', Icons.check_circle_outline),
              const SizedBox(width: 10),
              _statPill('12 km radius', Icons.location_on_outlined),
              const SizedBox(width: 10),
              _statPill('Rent & Buy', Icons.handshake_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
        tabs: const [
          Tab(text: 'Rent / Buy'),
          Tab(text: 'My Equipment'),
          Tab(text: 'Repair'),
        ],
      ),
    );
  }

  // ── Rent / Buy Tab ─────────────────────────────────────────────────────────
  Widget _buildRentBuyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeFilter(),
          _buildFeaturedEquipment(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('All Equipment', 'See All'),
                const SizedBox(height: 12),
                ..._equipmentList.map((e) => _equipmentCard(e)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Container(
      height: 48,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _types.length,
        itemBuilder: (context, i) {
          final selected = _selectedType == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = i),
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
                _types[i],
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

  Widget _buildFeaturedEquipment() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('⭐ Top Rated', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Combine Harvester\nModel 8010', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 6),
                  const Text('120 HP  •  Sahiwal  •  Available Now', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 10),
                  const Text('₹ 3,500 / day', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _featuredBtn('Book Now', kGreenLight, Colors.white, () {}),
                      const SizedBox(width: 8),
                      _featuredBtn('Details', Colors.transparent, Colors.white, () {}),
                    ],
                  ),
                ],
              ),
            ),
            const Text('🌾', style: TextStyle(fontSize: 58)),
          ],
        ),
      ),
    );
  }

  Widget _featuredBtn(String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: bg == Colors.transparent ? Border.all(color: Colors.white) : null,
        ),
        child: Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _equipmentCard(Map<String, dynamic> e) {
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
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: kGreenPale,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(e['emoji'] as String, style: const TextStyle(fontSize: 32)),
                  ),
                ),
                if (!(e['available'] as bool))
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Booked', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(e['name'] as String,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: (e['conditionColor'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(e['condition'] as String,
                            style: TextStyle(color: e['conditionColor'] as Color, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${e['type']}  •  ${e['hp']}  •  ${e['year']}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                      Text(e['location'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 12, color: Color(0xFFFFA726)),
                      Text('${e['rating']} (${e['reviews']})', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        e['pricePerDay'] as String,
                        style: const TextStyle(color: kGreenPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: kGreenPale,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(e['priceType'] as String,
                            style: const TextStyle(color: kGreenDark, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                      const Spacer(),
                      if (e['available'] as bool)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: kGreenPrimary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Book', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Unavailable', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ),
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

  // ── My Equipment Tab ───────────────────────────────────────────────────────
  Widget _buildMyEquipmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMyEquipmentStats(),
          const SizedBox(height: 20),
          _sectionHeader('My Listed Equipment', 'Add New'),
          const SizedBox(height: 12),
          ..._myEquipment.map((e) => _myEquipmentCard(e)),
          const SizedBox(height: 16),
          _buildBookingCalendarSection(),
        ],
      ),
    );
  }

  Widget _buildMyEquipmentStats() {
    return Row(
      children: [
        _myStatCard('Total Earnings', '₹ 15,700', Icons.currency_rupee, kGreenPrimary),
        const SizedBox(width: 12),
        _myStatCard('Total Bookings', '7', Icons.calendar_today, Color(0xFF00897B)),
      ],
    );
  }

  Widget _myStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myEquipmentCard(Map<String, dynamic> e) {
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: kGreenPale, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(e['emoji'] as String, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 4),
                Text('${e['bookings']} bookings  •  Earned: ${e['earned']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (e['statusColor'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(e['status'] as String,
                style: TextStyle(color: e['statusColor'] as Color, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGreenBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: kGreenPrimary, size: 20),
              SizedBox(width: 8),
              Text('Booking Calendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kGreenPale,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CalDay('1', 'Mon', false, false),
                _CalDay('2', 'Tue', false, false),
                _CalDay('3', 'Wed', true, false),
                _CalDay('4', 'Thu', true, false),
                _CalDay('5', 'Fri', false, true),
                _CalDay('6', 'Sat', false, false),
                _CalDay('7', 'Sun', false, false),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _calLegend(kGreenPrimary, 'Booked'),
              const SizedBox(width: 16),
              _calLegend(Colors.orange, 'Today'),
              const SizedBox(width: 16),
              _calLegend(Colors.grey.shade300, 'Free'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // ── Repair Tab ──────────────────────────────────────────────────────────────
  Widget _buildRepairTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRepairBanner(),
          const SizedBox(height: 20),
          _sectionHeader('Nearby Repair Services', 'View Map'),
          const SizedBox(height: 12),
          ..._repairServices.map((r) => _repairCard(r)),
          const SizedBox(height: 16),
          _buildRequestServiceCard(),
        ],
      ),
    );
  }

  Widget _buildRepairBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF33691E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Need a repair?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Find certified technicians near you for tractors, sprayers and more.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Text('Find Near Me →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const Text('🔧', style: TextStyle(fontSize: 50)),
        ],
      ),
    );
  }

  Widget _repairCard(Map<String, dynamic> r) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kGreenPale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.build_outlined, color: kGreenPrimary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 3),
                Text(r['type'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFFFFA726)),
                    Text(' ${r['rating']}  •  ${r['distance']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: (r['open'] as bool ? kGreenPrimary : Colors.grey).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (r['open'] as bool) ? 'Open' : 'Closed',
                  style: TextStyle(
                    color: (r['open'] as bool) ? kGreenPrimary : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.phone_outlined, color: kGreenPrimary, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestServiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGreenBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Request Service at Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
          const SizedBox(height: 6),
          const Text('A technician will visit your farm to inspect and repair.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.home_repair_service_outlined, color: Colors.white, size: 18),
              label: const Text('Request Visit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreenPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
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

// ── Calendar Day Widget ────────────────────────────────────────────────────────
class _CalDay extends StatelessWidget {
  final String date;
  final String day;
  final bool booked;
  final bool isToday;
  const _CalDay(this.date, this.day, this.booked, this.isToday);

  @override
  Widget build(BuildContext context) {
    Color bg = booked ? kGreenPrimary : (isToday ? Colors.orange : Colors.transparent);
    Color fg = (booked || isToday) ? Colors.white : Colors.black87;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: 10, color: booked || isToday ? Colors.white70 : Colors.grey)),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: fg)),
        ],
      ),
    );
  }
}