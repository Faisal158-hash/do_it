import 'dart:async';
import 'package:do_it/modules/orders/order_model.dart';
import 'package:do_it/modules/orders/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderService service = OrderService();

  /// CUSTOMER INPUT CONTROLLERS
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  /// STATE
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxBool isLoading = false.obs;

  /// STREAM SUBSCRIPTION
  StreamSubscription<List<OrderModel>>? subscription;

  @override
  void onInit() {
    super.onInit();

    /// ⚠️ if phone already exists (saved/login)
    if (phoneController.text.isNotEmpty) {
      listenToOrders(phoneController.text);
    }
  }

 void listenToOrders(String customerPhone) async {
  if (customerPhone.isEmpty) return;

  isLoading.value = true;

  // cancel previous subscription if exists
  await subscription?.cancel();

  // fetch existing orders once
  await fetchOrdersOnce(customerPhone);

  // start real-time stream
  subscription = service.streamOrders(customerPhone).listen(
    (data) {
      // append only new orders
      for (var order in data) {
        if (!orders.any((o) => o.id == order.id)) {
          orders.insert(0, order); // insert at top
        }
      }
      isLoading.value = false;
    },
    onError: (error) {
      print("STREAM ERROR: $error");
      isLoading.value = false;
    },
  );
}

Future<void> fetchOrdersOnce(String customerPhone) async {
  try {
    final result = await service.fetchOrders(customerPhone);

    // sort by created_at descending
    result.sort((a, b) => b.created_at.compareTo(a.created_at));

    // assign all fetched orders (initial load)
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

      await service.createOrder(order);

      /// ✅ Start listening AFTER first order
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
      await service.cancelOrder(orderId, reason);

      // ✅ remove the cancelled order from the list
      orders.removeWhere((o) => o.id == orderId);

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

      await service.updateOrder(orderId, updates);

      // ✅ Update local list copy
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final old = orders[index];
        orders[index] = OrderModel(
          id: old.id,
          name_en: old.name_en,
          name_ur: old.name_ur,
          image_url: old.image_url,
          quantity: quantity ?? old.quantity,
          price: price ?? old.price,
          total_price: (quantity ?? old.quantity) * (price ?? old.price),
          status: status ?? old.status,
          customer_name: old.customer_name,
          customer_phone: old.customer_phone,
          customer_address: old.customer_address,
          cancel_reason: old.cancel_reason,
          created_at: old.created_at,
        );
      }
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
    subscription?.cancel();
    super.onClose();
  }
}