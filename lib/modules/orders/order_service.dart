import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<void> createOrder(OrderModel order) async {
    await supabase.from('orders').insert(order.toMap());
  }

  Future<List<OrderModel>> fetchOrders(String customerPhone) async {
    final response = await supabase
        .from('orders')
        .select()
        .eq('customer_phone', customerPhone)
        .order('date', ascending: false);

    final data = response as List<dynamic>;
    return data.map((e) => OrderModel.fromMap(e)).toList();
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    await supabase
        .from('orders')
        .update({'status': 'Cancelled', 'cancel_reason': reason})
        .eq('id', orderId);
  }
}