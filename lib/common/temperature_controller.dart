import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TemperatureController extends GetxController {
  RxDouble temperature = 0.0.obs;

  Timer? _timer;

  // CHANGE THESE
  final String apiKey = "84128828b34da56ab951b1b13eb2d74b";
  final String city = "Lahore"; // or your required city
  final String countryCode = "PK";

  @override
  void onInit() {
    super.onInit();
    fetchTemperature();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchTemperature(),
    );
  }

  Future<void> fetchTemperature() async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city,$countryCode&appid=$apiKey&units=metric";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        temperature.value = data['main']['temp'].toDouble();
      }
    } catch (e) {
      // silently fail (important for production)
      // print(e);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
