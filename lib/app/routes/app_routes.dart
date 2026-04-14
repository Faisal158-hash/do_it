import 'package:do_it/modules/products/confirm_order_wrapper.dart';
import 'package:do_it/splash/splash_screen.dart';
import 'package:do_it/modules/home/home_view.dart';
import 'package:do_it/modules/products/product_view.dart';
import 'package:do_it/modules/cart/cart_view.dart';
import 'package:do_it/modules/orders/orders_view.dart';
import 'package:do_it/modules/profile/profile_view.dart';
import 'package:do_it/modules/home/home_controller.dart';
import 'package:do_it/modules/cart/cart_controller.dart';
import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:get/get.dart';

class AppRoutes {
  // Route name constants
  static const splash = '/splash';
  static const home = '/home';
  static const product = '/product';
  static const orders = '/orders';
  static const cart = '/cart';
  static const profile = '/profile';
  static const confirmorder = '/confirm-order';

  // GetX pages
  static final List<GetPage> routes = [
    // Splash
    GetPage(name: splash, page: () => SplashView()),

    // Home
    GetPage(
      name: home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),

    // Products
    GetPage(
      name: product,
      page: () => ProductView(product: null), // Keep existing logic
    ),

    // Cart
    GetPage(
      name: cart,
      page: () =>  CartPage(),
      binding: BindingsBuilder(() {
        Get.put(CartController());
      }),
    ),

    // Orders
    GetPage(
      name: orders,
      page: () => const OrderPage(productId: '', customerPhone: ''),
      binding: BindingsBuilder(() {
        Get.put(OrderController());
      }),
    ),

    // Profile
    GetPage(name: profile, page: () => ProfileView()),

    // Confirm Order Page (using wrapper)
    GetPage(
      name: confirmorder,
      page: () => const ConfirmOrderPageWrapper(),
    ),
  ];
}