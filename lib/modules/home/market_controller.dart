import 'package:flutter/material.dart';
import 'market_service.dart';

class MarketController extends ChangeNotifier {
  final MarketService _service = MarketService();

  List<Map<String, dynamic>> prices = [];
  String selectedCity = "";

  bool loading = false;

  Future<void> loadPrices() async {
    loading = true;
    notifyListeners();

    prices = await _service.getMarketPrices(
      city: selectedCity.isEmpty ? null : selectedCity,
    );

    loading = false;
    notifyListeners();
  }

  void setCity(String city) {
    selectedCity = city;
    loadPrices();
  }

  Stream<List<Map<String, dynamic>>> realtime() {
    return _service.marketStream();
  }
}