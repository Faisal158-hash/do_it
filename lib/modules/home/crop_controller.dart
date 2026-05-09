import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CropController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Observable state ────────────────────────────────────────────────────
  final RxList<Map<String, dynamic>> allCrops = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredCrops =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString activeFilter = 'Total'.obs; // 'Total' | 'Rabi' | 'Kharif'
  final RxString searchQuery = ''.obs;

  // ── Counts ───────────────────────────────────────────────────────────────
  int get rabiCount =>
      allCrops.where((c) => c['season'] == 'Rabi').length;
  int get kharifCount =>
      allCrops.where((c) => c['season'] == 'Kharif').length;
  int get totalCount => allCrops.length;

  // ── Seed data (inserted once when table is empty) ────────────────────────
  static const List<Map<String, dynamic>> _seedCrops = [
    {
      'name': 'Wheat',
      'season': 'Rabi',
      'growth_months': 5,
      'seeds_per_acre_kg': 40.0,
      'watering_frequency_days': 20,
      'watering_count_total': 4,
      'description':
          'Most important cereal crop of Pakistan. Sown in Nov–Dec, harvested Apr–May.',
      'products_needed': 'DAP, Urea, Weedicide, Fungicide',
      'gradient_start': '0xFF388E3C',
      'gradient_end': '0xFF66BB6A',
    },
    {
      'name': 'Maize',
      'season': 'Kharif',
      'growth_months': 4,
      'seeds_per_acre_kg': 8.0,
      'watering_frequency_days': 10,
      'watering_count_total': 6,
      'description':
          'High-yield cereal used for food & fodder. Sown Apr–May, harvested Aug–Sep.',
      'products_needed': 'Urea, Potash, Pesticide',
      'gradient_start': '0xFFF9A825',
      'gradient_end': '0xFFFFCC02',
    },
    {
      'name': 'Barseem',
      'season': 'Rabi',
      'growth_months': 5,
      'seeds_per_acre_kg': 12.0,
      'watering_frequency_days': 15,
      'watering_count_total': 8,
      'description':
          'Nutritious fodder legume for livestock. Sown Oct–Nov, cut every 25–30 days.',
      'products_needed': 'DAP, Rhizobium Inoculant',
      'gradient_start': '0xFF00796B',
      'gradient_end': '0xFF26A69A',
    },
    {
      'name': 'Charri (Sorghum)',
      'season': 'Kharif',
      'growth_months': 3,
      'seeds_per_acre_kg': 6.0,
      'watering_frequency_days': 12,
      'watering_count_total': 5,
      'description':
          'Drought-tolerant fodder crop. Sown Apr–Jun, harvested Jul–Sep.',
      'products_needed': 'Urea, Phosphate',
      'gradient_start': '0xFF5D4037',
      'gradient_end': '0xFF8D6E63',
    },
    {
      'name': 'Rice',
      'season': 'Kharif',
      'growth_months': 5,
      'seeds_per_acre_kg': 25.0,
      'watering_frequency_days': 5,
      'watering_count_total': 20,
      'description':
          'Major export crop. Transplanted Jun–Jul in flooded fields, harvested Oct–Nov.',
      'products_needed': 'DAP, Urea, Zinc Sulphate, Herbicide',
      'gradient_start': '0xFF0277BD',
      'gradient_end': '0xFF29B6F6',
    },
    {
      'name': 'Cotton',
      'season': 'Kharif',
      'growth_months': 6,
      'seeds_per_acre_kg': 8.0,
      'watering_frequency_days': 15,
      'watering_count_total': 6,
      'description':
          'Cash crop & textile raw material. Sown Apr–May, picked Sep–Nov.',
      'products_needed': 'Urea, DAP, Pesticide, Defoliant',
      'gradient_start': '0xFF6A1B9A',
      'gradient_end': '0xFFAB47BC',
    },
    {
      'name': 'Sugarcane',
      'season': 'Kharif',
      'growth_months': 12,
      'seeds_per_acre_kg': 2500.0,
      'watering_frequency_days': 20,
      'watering_count_total': 8,
      'description':
          'Long-duration crop. Setts planted Feb–Mar, harvested Jan–Feb next year.',
      'products_needed': 'Urea, Phosphate, Potash, Herbicide',
      'gradient_start': '0xFFBF360C',
      'gradient_end': '0xFFFF7043',
    },
    {
      'name': 'Sunflower',
      'season': 'Rabi',
      'growth_months': 4,
      'seeds_per_acre_kg': 2.0,
      'watering_frequency_days': 12,
      'watering_count_total': 5,
      'description':
          'Oilseed crop. Sown Jan–Feb, harvested Apr–May. Excellent rotation crop.',
      'products_needed': 'DAP, Urea, Boron',
      'gradient_start': '0xFFF57F17',
      'gradient_end': '0xFFFFCA28',
    },
    {
      'name': 'Potato',
      'season': 'Rabi',
      'growth_months': 3,
      'seeds_per_acre_kg': 500.0,
      'watering_frequency_days': 8,
      'watering_count_total': 7,
      'description':
          'High-value vegetable crop. Sown Oct–Nov, harvested Jan–Feb.',
      'products_needed': 'DAP, Urea, Potash, Fungicide',
      'gradient_start': '0xFF795548',
      'gradient_end': '0xFFA1887F',
    },
    {
      'name': 'Onion',
      'season': 'Rabi',
      'growth_months': 5,
      'seeds_per_acre_kg': 3.0,
      'watering_frequency_days': 10,
      'watering_count_total': 9,
      'description':
          'Important vegetable & export crop. Transplanted Oct–Nov, harvested Mar–Apr.',
      'products_needed': 'DAP, Urea, Potash, Fungicide',
      'gradient_start': '0xFFAD1457',
      'gradient_end': '0xFFEC407A',
    },
    {
      'name': 'Mung Bean',
      'season': 'Kharif',
      'growth_months': 2,
      'seeds_per_acre_kg': 8.0,
      'watering_frequency_days': 10,
      'watering_count_total': 4,
      'description':
          'Short-duration pulse. Sown May–Jun, harvested Jul–Aug. Fixes soil nitrogen.',
      'products_needed': 'DAP, Rhizobium',
      'gradient_start': '0xFF2E7D32',
      'gradient_end': '0xFF66BB6A',
    },
    {
      'name': 'Mustard',
      'season': 'Rabi',
      'growth_months': 4,
      'seeds_per_acre_kg': 3.0,
      'watering_frequency_days': 18,
      'watering_count_total': 3,
      'description':
          'Oilseed crop. Sown Oct, harvested Feb–Mar. Tolerates light frost.',
      'products_needed': 'Urea, Phosphate, Sulphur',
      'gradient_start': '0xFFE65100',
      'gradient_end': '0xFFFF8A65',
    },
    {
      'name': 'Chickpea',
      'season': 'Rabi',
      'growth_months': 5,
      'seeds_per_acre_kg': 20.0,
      'watering_frequency_days': 25,
      'watering_count_total': 2,
      'description':
          'Drought-tolerant pulse. Sown Nov, harvested Mar–Apr. Low water requirement.',
      'products_needed': 'DAP, Rhizobium, Fungicide',
      'gradient_start': '0xFFD84315',
      'gradient_end': '0xFFFF7043',
    },
    {
      'name': 'Tomato',
      'season': 'Kharif',
      'growth_months': 4,
      'seeds_per_acre_kg': 0.3,
      'watering_frequency_days': 7,
      'watering_count_total': 15,
      'description':
          'High-value vegetable. Transplanted Apr–May, harvested Jul–Sep. Needs staking.',
      'products_needed': 'DAP, Urea, Potash, Calcium, Pesticide',
      'gradient_start': '0xFFC62828',
      'gradient_end': '0xFFEF5350',
    },
  ];

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadCrops();

    // React to search & filter changes automatically
    ever(searchQuery, (_) => _applyFilter());
    ever(activeFilter, (_) => _applyFilter());
  }

  // ── Load crops from Supabase ──────────────────────────────────────────────
  Future<void> loadCrops() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _supabase
          .from('crops')
          .select()
          .order('name', ascending: true);

      final data = List<Map<String, dynamic>>.from(response as List);

      if (data.isEmpty) {
        await _supabase.from('crops').insert(_seedCrops);
        final seeded = await _supabase
            .from('crops')
            .select()
            .order('name', ascending: true);
        allCrops.value = List<Map<String, dynamic>>.from(seeded as List);
      } else {
        allCrops.value = data;
      }

      _applyFilter();
    } catch (e) {
      errorMessage.value = 'Failed to load crops. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Filter + search ───────────────────────────────────────────────────────
  void _applyFilter() {
    List<Map<String, dynamic>> list = [...allCrops];

    // Season filter
    if (activeFilter.value == 'Rabi') {
      list = list.where((c) => c['season'] == 'Rabi').toList();
    } else if (activeFilter.value == 'Kharif') {
      list = list.where((c) => c['season'] == 'Kharif').toList();
    }

    // Search filter
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list.where((c) {
        final name = (c['name'] ?? '').toLowerCase();
        final products = (c['products_needed'] ?? '').toLowerCase();
        final desc = (c['description'] ?? '').toLowerCase();
        return name.contains(q) ||
            products.contains(q) ||
            desc.contains(q);
      }).toList();
    }

    filteredCrops.value = list;
  }

  void setFilter(String filter) => activeFilter.value = filter;

  void setSearch(String query) => searchQuery.value = query;

  // ── Save new crop ─────────────────────────────────────────────────────────
  Future<bool> saveCrop({
    required String name,
    required String season,
    required int growthMonths,
    required double seedsPerAcre,
    required int waterFrequencyDays,
    required int waterCountTotal,
    required String productsNeeded,
    required String description,
  }) async {
    isSaving.value = true;
    try {
      await _supabase.from('crops').insert({
        'name': name,
        'season': season,
        'growth_months': growthMonths,
        'seeds_per_acre_kg': seedsPerAcre,
        'watering_frequency_days': waterFrequencyDays,
        'watering_count_total': waterCountTotal,
        'description': description,
        'products_needed': productsNeeded,
        'gradient_start': '0xFF2E7D32',
        'gradient_end': '0xFF66BB6A',
      });
      await loadCrops();
      return true;
    } catch (e) {
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String formatSeedsValue(dynamic val) {
    if (val == null) return '0';
    final d = (val as num).toDouble();
    return d % 1 == 0 ? d.toInt().toString() : d.toString();
  }
}