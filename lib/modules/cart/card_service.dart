import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartService {
  final supabase = Supabase.instance.client;

  /// Add item to cart
  Future<void> addToCart(CartModel item) async {
    await supabase.from('cart_items').insert(item.toMap());
  }

  /// Fetch cart with product details (JOIN with Product table)
  Future<List<dynamic>> getCartItems() async {
    return await supabase
        .from('cart_items')
        .select('*, Product(*)'); // important: Product not products
  }

  /// Remove item
  Future<void> removeFromCart(String id) async {
    await supabase.from('cart_items').delete().eq('id', id);
  }

  /// Clear full cart
  Future<void> clearCart() async {
    await supabase.from('cart_items').delete();
  }
}
