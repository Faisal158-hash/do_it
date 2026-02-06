import 'package:flutter/material.dart';

class OrdersController extends ChangeNotifier {
  final List<Map<String, dynamic>> orders = [
    {
      'product': 'Khal',
      'quantity': 2,
      'price': 100,
      'date': '15 Jan 2026',
      'status': 'Completed',
    },
    {
      'product': 'Chokar',
      'quantity': 5,
      'price': 80,
      'date': '14 Jan 2026',
      'status': 'Pending',
    },
  ];
}
