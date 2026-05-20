import 'package:flutter/material.dart';
import 'market_service.dart';

class MarketController extends ChangeNotifier {
  final MarketService _service = MarketService();

  String selectedCity = "";

  void setCity(String city) {
    selectedCity = city;
    notifyListeners();
  }

  //  SINGLE RESPONSIBILITY STREAM
  Stream<List<Map<String, dynamic>>> marketStreamFiltered() {
    return _service.marketStream(selectedCity.isEmpty ? null : selectedCity);
  }
}