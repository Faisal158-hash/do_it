import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'market_controller.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MarketController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Market Prices"),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [

          // 📍 CITY FILTER
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: controller.selectedCity.isEmpty
                  ? null
                  : controller.selectedCity,

              items: const ["Lahore", "Multan", "Faisalabad"]
                  .map(
                    (city) => DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    ),
                  )
                  .toList(),

              onChanged: (value) {
                controller.setCity(value ?? "");
              },

              decoration: const InputDecoration(
                labelText: "Select City",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 📊 LIVE STREAM (FIXED)
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.marketStreamFiltered(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No market data available"),
                  );
                }

                final data = snapshot.data!;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(
                        leading: Icon(
                          item['trend'] == 'up'
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: item['trend'] == 'up'
                              ? Colors.green
                              : Colors.red,
                        ),

                        title: Text(item['crop_name'] ?? ""),

                        subtitle: Text(item['city'] ?? ""),

                        trailing: Text(
                          "Rs ${item['price'] ?? 0}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}