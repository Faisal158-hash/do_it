import 'package:supabase_flutter/supabase_flutter.dart';

class MarketService {
  final supabase = Supabase.instance.client;

  // 📊 Get market prices
  Future<List<Map<String, dynamic>>> getMarketPrices({
    String? city,
  }) async {
    var query = supabase.from('market_prices').select();

    if (city != null && city.isNotEmpty) {
      query = query.eq('city', city);
    }

    final response = await query.order('updated_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // 💰 Add sell listing
  Future<void> addSellListing(Map<String, dynamic> data) async {
    await supabase.from('sell_listings').insert(data);
  }

  // 📈 realtime stream
  Stream<List<Map<String, dynamic>>> marketStream() {
    return supabase
        .from('market_prices')
        .stream(primaryKey: ['id']);
  }
}