import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  // CREATE ORDER
  Future<void> createOrder(OrderModel order) async {
    try {
      await supabase.from('orders').insert(order.toMap());
    } catch (e) {
      throw Exception("Failed to create order: $e");
    }
  }

  // FETCH ORDERS FOR CUSTOMER
  Future<List<OrderModel>> fetchOrders(String customerPhone) async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .eq('customer_phone', customerPhone)
          .order('created_at', ascending: false);

      // ignore: unnecessary_null_comparison, dead_code
      if (response == null) return [];
      final data = response as List<dynamic>;
      return data.map((e) => OrderModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception("Failed to fetch orders: $e");
    }
  }

  //  REAL-TIME STREAM
  Stream<List<OrderModel>> streamOrders(String customerPhone) {
    return supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_phone', customerPhone)
        .order('created_at', ascending: false)
        .map((data) => (data as List<dynamic>)
            .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
            .toList());
  }

  //  CANCEL ORDER
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await supabase
          .from('orders')
          .update({
            'status': 'cancelled',
            'cancel_reason': reason,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
    } catch (e) {
      throw Exception("Failed to cancel order: $e");
    }
  }

  // UPDATE ORDER STATUS (FOR ADMIN OR FIELDS)
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
      throw Exception("Failed to update status: $e");
    }
  }

  // UPDATE ORDER (FULL FLEXIBLE METHOD)
  Future<void> updateOrder(String orderId, Map<String, dynamic> fields) async {
    try {
      await supabase
          .from('orders')
          .update(fields)
          .eq('id', orderId);
    } catch (e) {
      throw Exception("Failed to update order: $e");
    }
  }
}