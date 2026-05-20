
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
      appBar: const AppHeaderView(pageTitle: "Subsidy", cartCount: 0, ordersCount: 0),
      bottomNavigationBar: const AppFooter(),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Government subsidy details for farmers..."),
          ),
          Positioned(bottom: 120, right: 20, child: TemperatureWidget()),
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }
}