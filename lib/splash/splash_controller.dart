// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:do_it/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final GetStorage _storage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    await Future.delayed(const Duration(seconds: 2));

    bool isFirstVisit = !(_storage.read('hasVisited') ?? false);

    if (isFirstVisit) {
      // Mark first visit
      _storage.write('hasVisited', true);
      // Optional: you can navigate to an Intro/Tutorial page here if needed
      // Get.offAllNamed(AppRoutes.intro);
    }

    // Navigate to Home in all cases
    Get.offAllNamed(AppRoutes.home);
  }
}
