import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  /// 🔹 CREATE ORDER
  Future<void> createOrder(OrderModel order) async {
    try {
      await supabase.from('orders').insert(order.toMap());
    } catch (e) {
      throw Exception("Failed to create order: $e");
    }
  }

  /// 🔹 FETCH ORDERS FOR CUSTOMER
  Future<List<OrderModel>> fetchOrders(String customerPhone) async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .eq('customer_phone', customerPhone)
          .order('created_at', ascending: false);

      if (response == null) return [];
      final data = response as List<dynamic>;

      // Parse each map using type-safe OrderModel
      return data
          .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch orders: $e");
    }
  }

  /// 🔹 REAL-TIME STREAM
  Stream<List<OrderModel>> streamOrders(String customerPhone) {
    return supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_phone', customerPhone)
        .order('created_at', ascending: false)
        .map((data) {
      // Each incoming event can be List<dynamic> or Map depending on Supabase
      // ignore: unnecessary_type_check
      if (data is List) {
        return data
            .map((e) => OrderModel.fromMap(e))
            .toList();
      // ignore: dead_code
      } else {
        return [];
      }
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

  /// 🔹 UPDATE ORDER STATUS (ADMIN OR FIELDS)
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

  /// 🔹 UPDATE ORDER (FULL FLEXIBLE METHOD)
  Future<void> updateOrder(String orderId, Map<String, dynamic> fields) async {
    try {
      fields['updated_at'] = DateTime.now().toIso8601String();

      await supabase.from('orders').update(fields).eq('id', orderId);
    } catch (e) {
      throw Exception("Failed to update order: $e");
    }
  }
}