import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartService {
  final supabase = Supabase.instance.client;

  // ✅ ADD TO CART (SAFE + UNIQUE CHECK)
  Future<CartModel?> addToCart(CartModel item) async {
    try {
      final existing = await supabase
          .from('cart_items')
          .select()
          .eq('user_id', item.userId)
          .eq('name_en', item.nameEn) // ⚠️ keep (since your DB has no product_id)
          .maybeSingle();

      if (existing != null) {
        final newQty = (existing['quantity'] as num? ?? 0) + item.quantity;
        final newTotal = newQty * item.price;

        final updated = await supabase
            .from('cart_items')
            .update({
              'quantity': newQty,
              'total_price': newTotal,
            })
            .eq('id', existing['id'])
            .select()
            .single();

        return CartModel.fromMap(updated);
      } else {
        // ✅ ensure user_id is always sent
        final inserted = await supabase
            .from('cart_items')
            .insert({
              ...item.toMap(),
              'user_id': item.userId,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();

        return CartModel.fromMap(inserted);
      }
    } catch (e) {
      print('❌ addToCart error: $e');
      return null;
    }
  }

  // ✅ FETCH CART ITEMS
  Future<List<CartModel>> getCartItems(String userId) async {
    try {
      final response = await supabase
          .from('cart_items')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => CartModel.fromMap(e))
          .toList();
    } catch (e) {
      print('❌ getCartItems error: $e');
      return [];
    }
  }

  // ✅ REMOVE ITEM
  Future<bool> removeFromCart(String id) async {
    try {
      await supabase.from('cart_items').delete().eq('id', id);
      return true;
    } catch (e) {
      print('❌ removeFromCart error: $e');
      return false;
    }
  }

  // ✅ CLEAR CART
  Future<bool> clearCart(String userId) async {
    try {
      await supabase.from('cart_items').delete().eq('user_id', userId);
      return true;
    } catch (e) {
      print('❌ clearCart error: $e');
      return false;
    }
  }

  // ✅ PLACE ORDER (IMPROVED SAFETY)
  Future<bool> placeOrder({
    required String userId,
    required String name,
    required String address,
    required String phone,
  }) async {
    try {
      final response = await supabase
          .from('cart_items')
          .select()
          .eq('user_id', userId);

      if (response.isEmpty) return false;

      final orders = (response as List).map((item) {
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
          'created_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      await supabase.from('orders').insert(orders);

      await clearCart(userId);

      return true;
    } catch (e) {
      print('❌ placeOrder error: $e');
      return false;
    }
  }
}