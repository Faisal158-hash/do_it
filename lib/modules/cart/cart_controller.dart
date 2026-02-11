import 'package:do_it/modules/cart/card_service.dart';

import 'cart_model.dart';

class CartController {
  final CartService _service = CartService();

  Future<void> addToCart(String productId, int quantity) async {
    final item = CartModel(productId: productId, quantity: quantity);

    await _service.addToCart(item);
  }

  Future<List<dynamic>> fetchCartItems() async {
    return await _service.getCartItems();
  }

  Future<void> removeItem(String id) async {
    await _service.removeFromCart(id);
  }

  Future<void> clearCart() async {
    await _service.clearCart();
  }
}
