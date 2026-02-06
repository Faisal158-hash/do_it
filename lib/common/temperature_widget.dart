import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

import 'temperature_controller.dart';

class TemperatureWidget extends StatelessWidget {
  TemperatureWidget({super.key});

  final TemperatureController controller = Get.find<TemperatureController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${controller.temperature.value.toStringAsFixed(1)} °C',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
