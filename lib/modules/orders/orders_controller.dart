import 'package:do_it/modules/orders/order_model.dart';
import 'package:do_it/modules/orders/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderService _service = OrderService();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchOrders(String customerPhone) async {
    try {
      isLoading.value = true;
      final list = await _service.fetchOrders(customerPhone);
      orders.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> placeOrder(String productId, String productName, int quantity,
      double price) async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      return false;
    }

    final order = OrderModel(
      id: '', // Supabase auto-id
      productId: productId,
      productName: productName,
      quantity: quantity,
      price: price,
      status: 'Pending',
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,
      date: DateTime.now(),
    );

    await _service.createOrder(order);
    return true;
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    await _service.cancelOrder(orderId, reason);
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(
          status: 'Cancelled', cancelReason: reason); // reactive update
    }
  }

  void disposeControllers() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}

extension OrderModelCopy on OrderModel {
  OrderModel copyWith({
    String? status,
    String? cancelReason,
  }) {
    return OrderModel(
      id: id,
      productId: productId,
      productName: productName,
      quantity: quantity,
      price: price,
      status: status ?? this.status,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      cancelReason: cancelReason ?? this.cancelReason,
      date: date,
    );
  }
}