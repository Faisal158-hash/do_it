import 'package:do_it/modules/cart/cart_service.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_model.dart';

class CartController extends GetxController {
  final CartService _service = CartService();
  final supabase = Supabase.instance.client;

  String? get userId => supabase.auth.currentUser?.id;

  var cartItems = <CartModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final uid = userId;
    if (uid == null) return;

    try {
      isLoading.value = true;

      final data = await _service.getCartItems(uid);
      cartItems.assignAll(data);
    } catch (e) {
      print("Cart fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart({
    required String nameEn,
    required String nameUr,
    required String imageUrl,
    required double price,
    required int stock,
  }) async {
    final uid = userId;
    if (uid == null) return;

    final item = CartModel(
      userId: uid,
      nameEn: nameEn,
      nameUr: nameUr,
      imageUrl: imageUrl,
      price: price,
      quantity: 1,
      stock: stock,
      totalPrice: price,
    );

    await _service.addToCart(item);

    // safer refresh (gives DB time to commit)
    await Future.delayed(const Duration(milliseconds: 200));
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
    final uid = userId;
    if (uid == null) return;

    await _service.placeOrder(
      userId: uid,
      name: name,
      address: address,
      phone: phone,
    );

    await fetchCartItems();
  }
}