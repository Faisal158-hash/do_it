import 'package:do_it/modules/cart/card_service.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartController extends GetxController {
  final CartService _service = CartService();
  final supabase = Supabase.instance.client;

  String get userId => supabase.auth.currentUser!.id;

  var cartItems = <CartModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCartItems();
    super.onInit();
  }

  Future<void> fetchCartItems() async {
    isLoading.value = true;
    final data = await _service.getCartItems(userId);
    cartItems.assignAll(data);
    isLoading.value = false;
  }

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
    await fetchCartItems();
  }

  Future<void> removeItem(String id) async {
    await _service.removeFromCart(id);
    await fetchCartItems();
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

    await fetchCartItems();
  }
}