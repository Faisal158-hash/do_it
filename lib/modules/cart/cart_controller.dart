import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Khal',
      'price': 100,
      'quantity': 2,
      'image': 'assets/images/khal.png',
    },
    {
      'name': 'Chokar',
      'price': 80,
      'quantity': 1,
      'image': 'assets/images/chokar.png',
    },
  ];

  int get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity'] as int),
    );
  }
}
