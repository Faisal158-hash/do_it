import 'package:do_it/modules/orders/order_model.dart';
import 'package:do_it/modules/orders/order_service.dart';
import 'package:flutter/material.dart';

class OrderController {
  final OrderService _service = OrderService();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  Future<bool> placeOrder(String productId, int quantity) async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      return false;
    }

    final order = OrderModel(
      productId: productId,
      quantity: quantity,
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,
    );

    await _service.createOrder(order);

    return true;
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
