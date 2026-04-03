import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  /// 🔹 CREATE ORDER (FIXED FOR SUPABASE)
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final response = await supabase
          .from('orders')
          .insert(order.toMap())
          .select()
          .single(); // 🔑 return inserted row

      return OrderModel.fromMap(response);
    } catch (e) {
      throw Exception("Failed to create order: $e");
    }
  }

  /// 🔹 FETCH ALL ORDERS FOR CUSTOMER
  Future<List<OrderModel>> fetchOrders(String customerPhone) async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .eq('customer_phone', customerPhone)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

      print("FETCHED ORDERS: ${data.length}");

      return data.map((e) => OrderModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch orders: $e");
    }
  }

  /// 🔹 REAL-TIME STREAM (KEEPED AS IT IS - CORRECT)
  Stream<List<OrderModel>> streamOrders(String customerPhone) {
    return supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_phone', customerPhone)
        .order('created_at', ascending: false)
        .map((event) {
          final List<Map<String, dynamic>> data =
              List<Map<String, dynamic>>.from(event);

          print("STREAM ORDERS: ${data.length}");

          return data.map((e) => OrderModel.fromMap(e)).toList();
        });
  }

  /// 🔹 CANCEL ORDER
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await supabase
          .from('orders')
          .update({
            'status': 'Cancelled',
            'cancel_reason': reason,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
    } catch (e) {
      throw Exception("Failed to cancel order: $e");
    }
  }

  /// 🔹 UPDATE ORDER STATUS
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await supabase
          .from('orders')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
    } catch (e) {
      throw Exception("Failed to update order status: $e");
    }
  }

  /// 🔹 UPDATE ORDER (GENERIC)
  Future<void> updateOrder(String orderId, Map<String, dynamic> fields) async {
    try {
      fields['updated_at'] = DateTime.now().toIso8601String();

      await supabase.from('orders').update(fields).eq('id', orderId);
    } catch (e) {
      throw Exception("Failed to update order: $e");
    }
  }
}