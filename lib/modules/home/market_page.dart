import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'market_controller.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MarketController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Market Prices"),
        backgroundColor: Colors.green[700],
      ),

      body: Column(
        children: [

          // 📍 CITY FILTER
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField(
              value: controller.selectedCity.isEmpty
                  ? null
                  : controller.selectedCity,
              items: ["Lahore", "Multan", "Faisalabad"]
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
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

          // 📊 LIVE DATA
          Expanded(
            child: StreamBuilder(
              stream: controller.realtime(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Icon(
                          item['trend'] == 'up'
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: item['trend'] == 'up'
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(item['crop_name']),
                        subtitle: Text(item['city']),
                        trailing: Text(
                          "Rs ${item['price']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
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