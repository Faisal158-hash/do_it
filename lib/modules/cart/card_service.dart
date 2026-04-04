import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartService {
  final supabase = Supabase.instance.client;

  /// ADD TO CART (WITH DUPLICATE CHECK)
  Future<void> addToCart(CartModel item) async {
    final existing = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', item.userId)
        .eq('name_en', item.nameEn)
        .maybeSingle();

    if (existing != null) {
      int newQty = existing['quantity'] + item.quantity;

      await supabase.from('cart_items').update({
        'quantity': newQty,
        'total_price': newQty * item.price,
      }).eq('id', existing['id']);
    } else {
      await supabase.from('cart_items').insert(item.toMap());
    }
  }

  /// FETCH CART (NO JOIN)
  Future<List<CartModel>> getCartItems(String userId) async {
    final response = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', userId);

    return response.map((e) => CartModel.fromMap(e)).toList();
  }

  /// REMOVE ITEM
  Future<void> removeFromCart(String id) async {
    await supabase.from('cart_items').delete().eq('id', id);
  }

  /// CLEAR CART
  Future<void> clearCart(String userId) async {
    await supabase.from('cart_items').delete().eq('user_id', userId);
  }

  /// PLACE ORDER FROM CART 🔥
  Future<void> placeOrder({
    required String userId,
    required String name,
    required String address,
    required String phone,
  }) async {
    final cartItems = await supabase
        .from('cart_items')
        .select()
        .eq('user_id', userId);

    if (cartItems.isEmpty) return;

    await supabase.from('orders').insert(
      cartItems.map((item) {
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
      }).toList(),
    );

    await clearCart(userId);
  }
}