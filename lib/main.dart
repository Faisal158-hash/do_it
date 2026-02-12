import 'package:do_it/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:do_it/app/bindings/initial_binding.dart';
import 'package:do_it/app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage
  await GetStorage.init();

  // Supabase
  await Supabase.initialize(
    url: 'https://hhruwroykwncfvafpzob.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhocnV3cm95a3duY2Z2YWZwem9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MDMwNTUsImV4cCI6MjA4NDM3OTA1NX0.e0lbbBhjSiwHpcgoGJpuFH1x3VnBDB_a1sueLrE4LRw',
  );

  Get.put(AuthController());

  runApp(const KisanTradersApp());
}

class KisanTradersApp extends StatelessWidget {
  const KisanTradersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kisan Traders',
      debugShowCheckedModeBanner: false,

      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
      ),
    );
  }
}
