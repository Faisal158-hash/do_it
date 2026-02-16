import 'package:do_it/common/temperature_controller.dart';
import 'package:do_it/modules/auth/login_controller.dart';
import 'package:do_it/modules/auth/signup_controller.dart';
import 'package:do_it/modules/orders/orders_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/cart/cart_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(SessionController(), permanent: true);
    // Get.put(AuthController(), permanent: true);
    Get.put(TemperatureController(), permanent: true);
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => SignupController());
    Get.put(HomeController());
    Get.put(CartController());
    Get.put(OrderController());
  }
}
