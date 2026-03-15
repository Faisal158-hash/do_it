import 'package:do_it/modules/products/product_model.dart';
import 'package:flutter/material.dart';

void showPlaceOrderPopup(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Place Order: ${product.nameEn}"),
      content: const Text("Your order has been placed successfully!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}