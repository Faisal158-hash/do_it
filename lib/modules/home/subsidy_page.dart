import 'package:flutter/material.dart';
import '../../common/app_header.dart';
import '../../common/app_footer.dart';
import '../../common/date_time_widget.dart';
import '../../common/temperature_widget.dart';

class SubsidyPage extends StatelessWidget {
  const SubsidyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: "Subsidy",
        cartCount: 0,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      body: Stack(
        children: [
          // ✅ Main Content (Scrollable)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Government Subsidies for Farmers",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  Text(
                    "The government provides various subsidies to support farmers and improve agricultural productivity.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  Text("• Fertilizer Subsidy"),
                  Text("  Helps reduce the cost of fertilizers for farmers."),

                  SizedBox(height: 10),
                  Text("• Seed Subsidy"),
                  Text("  Provides high-quality seeds at lower prices."),

                  SizedBox(height: 10),
                  Text("• Equipment Subsidy"),
                  Text("  Financial support for buying tractors and machinery."),

                  SizedBox(height: 10),
                  Text("• Irrigation Support"),
                  Text("  Assistance for tube wells, drip irrigation, etc."),

                  SizedBox(height: 10),
                  Text("• Crop Insurance"),
                  Text("  Protection against losses due to weather or disasters."),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // ✅ Bottom Right Widgets (Proper Alignment)
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}