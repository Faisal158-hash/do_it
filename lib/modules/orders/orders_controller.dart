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

    // Cancel previous subscription
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

  /// 🔹 PLACE ORDER
  Future<bool> placeOrder({
    required String productId,
    required String productName,
    String? productNameUr,
    required String imageUrl,
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

      final order = OrderModel(
        id: '',

        /// PRODUCT DATA
        name_en: productName,
        name_ur: productNameUr,
        image_url: imageUrl,

        /// ORDER DATA
        quantity: quantity,
        price: price,
        total_price: total.toDouble(),
        status: 'pending',

        /// CUSTOMER
        customer_name: nameController.text,
        customer_phone: phoneController.text,
        customer_address: addressController.text,

        /// OPTIONAL
        cancel_reason: null,
        created_at: DateTime.now(),
      );

      await _service.createOrder(order);
      clearFields();

      Get.snackbar(
        "Success",
        "Order Confirmed",
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 CANCEL ORDER
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _service.cancelOrder(orderId, reason);

      Get.snackbar(
        "Cancelled",
        "Order has been cancelled",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
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
      await _service.updateOrder(orderId, {
        'quantity': ?quantity,
        'price': ?price,
        'status': ?status,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Error updating order: $e");
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
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
    /// Dispose controllers
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    /// Cancel subscription
    _subscription?.cancel();

    super.onClose();
  }
}