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
  StreamSubscription<List<OrderModel>>? _subscription;

  /// 🔹 START REAL-TIME LISTENING
  void listenToOrders(String customerPhone) {
    if (customerPhone.isEmpty) return; // prevent empty calls

    isLoading.value = true;

    // cancel previous stream
    _subscription?.cancel();

    _subscription = _service.streamOrders(customerPhone).listen(
      (data) {
        orders.assignAll(data); // 🔥 updates UI automatically
        isLoading.value = false;
      },
      onError: (error) {
        print("STREAM ERROR: $error");
        isLoading.value = false;
      },
    );
  }

  /// 🔹 PLACE ORDER
  Future<bool> placeOrder({
    required String name_en,
    String? name_ur,
    required String image_url,
    required int quantity,
    required double price,
  }) async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;

    try {
      final total = quantity * price;

      /// 🔥 SAVE phone BEFORE clearing
      final currentPhone = phoneController.text;

      final order = OrderModel(
        id: '',
        name_en: name_en,
        name_ur: name_ur,
        image_url: image_url,
        quantity: quantity,
        price: price,
        total_price: total,
        status: 'pending',
        customer_name: nameController.text,
        customer_phone: currentPhone,
        customer_address: addressController.text,
        cancel_reason: null,
        created_at: DateTime.now(),
      );

      await _service.createOrder(order);

      /// 🔥 FIRST refresh data
      listenToOrders(currentPhone);

      /// THEN clear fields
      clearFields();

      Get.snackbar(
        "Success",
        "Order Confirmed",
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 CANCEL ORDER
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      final currentPhone = phoneController.text;

      await _service.cancelOrder(orderId, reason);

      /// refresh list
      listenToOrders(currentPhone);

      Get.snackbar(
        "Cancelled",
        "Order has been cancelled",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 🔹 UPDATE ORDER
  Future<void> updateOrder(
    String orderId, {
    int? quantity,
    double? price,
    String? status,
  }) async {
    try {
      final currentPhone = phoneController.text;

      final Map<String, dynamic> updates = {};

      if (quantity != null) updates['quantity'] = quantity;
      if (price != null) updates['price'] = price;
      if (status != null) updates['status'] = status;

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _service.updateOrder(orderId, updates);

      /// refresh list
      listenToOrders(currentPhone);
    } catch (e) {
      print("Error updating order: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 🔹 CLEAR INPUTS
  void clearFields() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _subscription?.cancel();
    super.onClose();
  }
}