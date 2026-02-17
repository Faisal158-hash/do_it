// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:do_it/splash/splash_screen.dart';
import 'package:do_it/modules/home/home_view.dart';
import 'package:do_it/modules/products/product_view.dart';
import 'package:do_it/modules/cart/cart_view.dart';
import 'package:do_it/modules/orders/orders_view.dart';
import 'package:do_it/modules/profile/profile_view.dart';
import 'package:do_it/modules/home/home_controller.dart';
import 'package:do_it/modules/cart/cart_controller.dart';
import 'package:do_it/modules/orders/orders_controller.dart';

class AppRoutes {
  // Route name constants
  static const splash = '/splash';
  static const home = '/home';
  static const product = '/product';
  static const orders = '/orders';
  static const cart = '/cart';
  static const profile = '/profile';

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
    GetPage(name: product, page: () => const ProductView(product: null)),

    // Cart
    GetPage(
      name: cart,
      page: () => const CartPage(),
      binding: BindingsBuilder(() {
        Get.put(CartController());
      }),
    ),

    // Orders
    GetPage(
      name: orders,
      page: () => const OrderPage(productId: ''),
      binding: BindingsBuilder(() {
        Get.put(OrderController());
      }),
    ),

    // Profile
    GetPage(name: profile, page: () => ProfileView()),
  ];
}
