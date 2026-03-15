import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrderController controller;

  const OrderCard({super.key, required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    final total = order.quantity * order.price;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.productName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _statusChip(order.status),
              ],
            ),
            const SizedBox(height: 6),
            Text('Date: ${order.date.toLocal().toString().split(' ')[0]}'),
            Text('Quantity: ${order.quantity} kg'),
            Text('Rate: Rs ${order.price} / kg'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rs $total',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800),
                ),
                if (order.status != 'Cancelled' && order.status != 'Completed')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _showCancelDialog(context),
                    child: const Text("Cancel Order"),
                  ),
              ],
            ),
            if (order.cancelReason != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Cancel Reason: ${order.cancelReason}',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = status == 'Completed'
        ? Colors.green
        : status == 'Cancelled'
            ? Colors.red
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Order'),
        content: TextField(
          controller: reasonController,
          decoration:
              const InputDecoration(hintText: "Reason for cancelling order"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                controller.cancelOrder(order.id, reasonController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}