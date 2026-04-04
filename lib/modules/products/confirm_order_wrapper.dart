import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Confirm_order_page.dart';
import 'product_model.dart';

class ConfirmOrderPageWrapper extends StatelessWidget {
  const ConfirmOrderPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    // Check if product is passed correctly
    if (args == null || args is! Product) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Product data missing!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return ConfirmOrderPage(product: args);
  }
}