import 'package:do_it/modules/products/product_model.dart';
import 'package:flutter/material.dart';

void showDetailsPopup(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Product Details"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("English Name: ${product.nameEn}"),
          Text("Urdu Name: ${product.nameUr}"),
          Text("Price: Rs ${product.price}"),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Image.network(
              product.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.image_not_supported)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}