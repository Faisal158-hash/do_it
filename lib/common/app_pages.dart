//import 'package:do_it/modules/auth/login_view.dart';
//import 'package:do_it/modules/auth/signup_view.dart';
import 'package:do_it/splash/splash_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:do_it/app/routes/app_routes.dart';
import 'package:do_it/modules/home/home_view.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => SplashView()),
    GetPage(name: AppRoutes.home, page: () => HomeView()),
    // GetPage(name: AppRoutes.login, page: () => LoginPopup()),
    // GetPage(name: AppRoutes.signup, page: () => SignupPopup()),
  ];
}
