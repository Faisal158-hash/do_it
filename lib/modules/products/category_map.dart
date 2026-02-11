import 'package:flutter/material.dart';

/// Category names used across the app
const Map<String, String> categoryNames = {
  "animal_feeds": "Animal Feeds",
  "seeds": "Seeds",
  "fertilizers": "Fertilizers",
  "farming_tools": "Farming Tools",
};

/// Test widget to verify the map is working
class CategoryTestPage extends StatelessWidget {
  const CategoryTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category Map Test")),
      body: Center(
        child: Text(
          categoryNames["seeds"] ?? "Unknown",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
