import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<void> createOrder(OrderModel order) async {
    await supabase.from('orders').insert(order.toMap());
  }
}
