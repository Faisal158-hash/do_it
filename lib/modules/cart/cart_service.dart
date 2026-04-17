import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartService {
  final supabase = Supabase.instance.client;

  Future<void> addToCart(CartModel item) async {
    final existing = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', item.userId)
        .eq('name_en', item.nameEn)
        .maybeSingle();

    if (existing != null) {
      final newQty =
          (existing['quantity'] as num? ?? 0) + item.quantity;

      await supabase.from('cart_items').update({
        'quantity': newQty,
        'total_price': newQty * item.price,
      }).eq('id', existing['id']);
    } else {
      await supabase.from('cart_items').insert(item.toMap());
    }
  }

  Future<List<CartModel>> getCartItems(String userId) async {
    final response = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', userId);

    final List data = response as List;

    return data
        .map((e) => CartModel.fromMap(e))
        .toList();
  }

  Future<void> removeFromCart(String id) async {
    await supabase.from('cart_items').delete().eq('id', id);
  }

  Future<void> clearCart(String userId) async {
    await supabase.from('cart_items').delete().eq('user_id', userId);
  }

  Future<void> placeOrder({
    required String userId,
    required String name,
    required String address,
    required String phone,
  }) async {
    final response = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', userId);

    final List cartItems = response as List;

    if (cartItems.isEmpty) return;

    final orders = cartItems.map((item) {
      return {
        'name_en': item['name_en'],
        'name_ur': item['name_ur'],
        'image_url': item['image_url'],
        'price': item['price'],
        'quantity': item['quantity'],
        'total_price': item['total_price'],
        'customer_name': name,
        'customer_address': address,
        'customer_phone': phone,
        'status': 'pending',
      };
    }).toList();

    await supabase.from('orders').insert(orders);

    await clearCart(userId);
  }
}