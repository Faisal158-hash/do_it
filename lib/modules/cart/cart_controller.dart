import 'package:do_it/modules/cart/card_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartController {
  final CartService _service = CartService();
  final supabase = Supabase.instance.client;

  String get userId => supabase.auth.currentUser!.id;

  Future<void> addToCart({
    required String nameEn,
    required String nameUr,
    required String imageUrl,
    required double price,
    required int stock,
  }) async {
    final item = CartModel(
      userId: userId,
      nameEn: nameEn,
      nameUr: nameUr,
      imageUrl: imageUrl,
      price: price,
      quantity: 1,
      stock: stock,
      totalPrice: price,
    );

    await _service.addToCart(item);
  }

  Future<List<CartModel>> fetchCartItems() async {
    return await _service.getCartItems(userId);
  }

  Future<void> removeItem(String id) async {
    await _service.removeFromCart(id);
  }

  Future<void> placeOrder({
    required String name,
    required String address,
    required String phone,
  }) async {
    await _service.placeOrder(
      userId: userId,
      name: name,
      address: address,
      phone: phone,
    );
  }
}