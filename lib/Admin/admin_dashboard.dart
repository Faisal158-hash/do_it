import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  int index = 0;
  final box = GetStorage();

  final pages = [
    const Center(child: Text("Dashboard Home")),
    const Center(child: Text("Products")),
    const Center(child: Text("Orders")),
    const Center(child: Text("Users")),
  ];
  @override
  Widget build(BuildContext context) {
    String? role = box.read('role');
    //  PROTECTION
     if (role != 'admin') {
    Future.microtask(() => Get.offAllNamed('/login'));
    return const SizedBox(); // blank screen temporarily
  }

//   return Scaffold(
//     body: Center(
//       child: Text("Admin Dashboard"),
//     ),
//   );
// }
    return Scaffold(
      body: Row(
        children: [

          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) {
              setState(() => index = i);
            },
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.dashboard), label: Text("Dashboard")),
              NavigationRailDestination(
                  icon: Icon(Icons.shopping_bag), label: Text("Products")),
              NavigationRailDestination(
                  icon: Icon(Icons.receipt_long), label: Text("Orders")),
              NavigationRailDestination(
                  icon: Icon(Icons.people), label: Text("Users")),
            ],
          ),

          const VerticalDivider(width: 1),

          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}