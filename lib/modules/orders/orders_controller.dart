import 'dart:async';

import 'package:do_it/modules/orders/order_model.dart';
import 'package:do_it/modules/orders/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderService _service = OrderService();

  /// CUSTOMER INPUT CONTROLLERS
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  /// STATE
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxBool isLoading = false.obs;

  /// STREAM SUBSCRIPTION
  Stream<List<OrderModel>>? orderStream;
  StreamSubscription<List<OrderModel>>? _subscription;

  /// 🔹 START REAL-TIME LISTENING
  void listenToOrders(String customerPhone) {
    isLoading.value = true;

    /// cancel old subscription (IMPORTANT)
    _subscription?.cancel();

    orderStream = _service.streamOrders(customerPhone);

    _subscription = orderStream!.listen(
      (data) {
        orders.assignAll(data);
        isLoading.value = false;
      },
      onError: (error) {
        print("STREAM ERROR: $error");
        isLoading.value = false;
      },
    );
  }

  /// 🔹 PLACE ORDER (MATCHES SUPABASE)
  Future<bool> placeOrder({
    required String productName,
    String? productNameUr,
    required String imageUrl,
    required int quantity,
    required double price,
  }) async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      return false;
    }

    final total = quantity * price;

    final order = OrderModel(
      id: '',

      /// PRODUCT DATA (MATCH DB)
      productName: productName,
      productNameUr: productNameUr,
      imageUrl: imageUrl,

      /// ORDER DATA
      quantity: quantity,
      price: price,
      totalPrice: total.toDouble(),
      status: 'pending',

      /// CUSTOMER
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,

      /// OPTIONAL
      cancelReason: null,
      date: DateTime.now(),
      productId: '',
    );

    await _service.createOrder(order);

    return true;
  }

  /// 🔹 CANCEL ORDER
  Future<void> cancelOrder(String orderId, String reason) async {
    await _service.cancelOrder(orderId, reason);
    // ✅ No manual update needed (real-time handles it)
  }

  /// 🔹 CLEAR INPUTS
  void clearFields() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }

  @override
  void onClose() {
    /// dispose controllers
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    /// cancel stream (VERY IMPORTANT)
    _subscription?.cancel();

    super.onClose();
  }
}
