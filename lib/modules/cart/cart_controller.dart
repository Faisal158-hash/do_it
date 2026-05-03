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
  var isAdding = false.obs;

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get totalItems =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // ✅ FETCH
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

  // ✅ ADD TO CART
  Future<void> addCart({
    required String nameEn,
    required String nameUr,
    required String imageUrl,
    required double price,
    required String stock,
    required int quantity,
    required String description, // ✅ ADDED — was missing, CartModel now requires it
  }) async {
    if (isAdding.value) return;
    isAdding.value = true;

    final uid = userId;
    if (uid == null) {
      isAdding.value = false;
      return;
    }

    try {
      final item = CartModel(
        userId: uid,
        nameEn: nameEn,
        nameUr: nameUr,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
        stock: stock,
        totalPrice: price * quantity,
        description: description, // ✅ ADDED — was missing from CartModel constructor
      );

      final result = await _service.addToCart(item);

      if (result != null) {
        final index = cartItems.indexWhere((e) => e.nameEn == nameEn);

        if (index != -1) {
          cartItems[index] = cartItems[index].copyWith(
            quantity: result.quantity,
            totalPrice: result.totalPrice,
          );
        } else {
          cartItems.add(result);
        }
      } else {
        await fetchCartItems();
      }

      Get.snackbar("Success", "Added to Cart");
    } catch (e) {
      print("Add to cart error: $e");
      Get.snackbar("Error", "Failed to add item");
    } finally {
      isAdding.value = false;
    }
  }

  // ✅ REMOVE ITEM
  Future<void> removeItem(String id) async {
    try {
      final success = await _service.removeFromCart(id);

      if (success) {
        cartItems.removeWhere((e) => e.id == id);
      } else {
        await fetchCartItems();
      }
    } catch (e) {
      print("Remove error: $e");
    }
  }

  // ✅ PLACE ORDER — return bool so cart_view can react correctly
  Future<bool> placeOrder({ // ✅ FIXED — was Future<void>, view needs Future<bool>
    required String name,
    required String address,
    required String phone,
  }) async {
    final uid = userId;
    if (uid == null) return false; // ✅ FIXED

    try {
      final success = await _service.placeOrder(
        userId: uid,
        name: name,
        address: address,
        phone: phone,
      );

      if (success) {
        cartItems.clear();
        Get.snackbar("Success", "Order Placed");
      }

      return success; // ✅ FIXED — now returns actual result to cart_view
    } catch (e) {
      print("Order error: $e");
      return false; // ✅ FIXED
    }
  }
}