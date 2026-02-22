import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'temperature_controller.dart';

class TemperatureWidget extends StatelessWidget {
  TemperatureWidget({super.key});

  final TemperatureController controller =
      Get.find<TemperatureController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // ⭐ responsive sizing
    final isMobile = width < 600;
    final paddingHorizontal = width * 0.03;
    final paddingVertical = width * 0.02;
    final fontSize = isMobile ? 13.0 : 16.0;
    final iconSize = isMobile ? 18.0 : 22.0;
    final borderRadius = width * 0.04;

    return Obx(
      () => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),

        /// ⭐ glass blur effect (modern UI)
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            /// ⭐ modern layout
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Weather Icon
                Icon(
                  Icons.thermostat_outlined,
                  color: Colors.white70,
                  size: iconSize,
                ),

                SizedBox(width: width * 0.015),

                /// Temperature Text
                Text(
                  '${controller.temperature.value.toStringAsFixed(1)} °C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}