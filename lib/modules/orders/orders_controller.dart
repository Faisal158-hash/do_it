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

  /// ✅ AUTO LOAD WHEN CONTROLLER STARTS
  @override
  void onInit() {
    super.onInit();

    /// ⚠️ IMPORTANT: if phone already exists (saved/login)
    if (phoneController.text.isNotEmpty) {
      listenToOrders(phoneController.text);
    }
  }

  /// 🔹 LISTEN TO ORDERS WITH INITIAL FETCH
  void listenToOrders(String customerPhone) async {
    if (customerPhone.isEmpty) return;

    isLoading.value = true;

    /// cancel previous subscription if exists
    await _subscription?.cancel();

    /// ✅ fetch existing orders once
    await fetchOrdersOnce(customerPhone);

    /// start real-time stream
    _subscription = _service.streamOrders(customerPhone).listen(
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

  /// 🔹 FETCH EXISTING ORDERS ONCE
  Future<void> fetchOrdersOnce(String customerPhone) async {
    try {
      final result = await _service.fetchOrders(customerPhone);
      orders.assignAll(result);
    } catch (e) {
      print("Initial fetch error: $e");
    }
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

      /// ✅ IMPORTANT: Start listening AFTER first order
      listenToOrders(currentPhone);

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
      await _service.cancelOrder(orderId, reason);

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
      final Map<String, dynamic> updates = {};

      if (quantity != null) updates['quantity'] = quantity;
      if (price != null) updates['price'] = price;
      if (status != null) updates['status'] = status;

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _service.updateOrder(orderId, updates);
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

  /// 🔔 ORDER COUNT FOR HEADER
  int get orderCount => orders.length;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _subscription?.cancel();
    super.onClose();
  }
}