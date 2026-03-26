import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrderController controller;

  const OrderCard({super.key, required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final total = order.quantity * order.price;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      elevation: 3,
      shadowColor: colors.shadow.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// TOP ROW (IMAGE + INFO)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PRODUCT IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    order.image_url,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),

                const SizedBox(width: 12),

                /// PRODUCT INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME ENGLISH
                      Text(
                        order.name_en,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// NAME URDU
                      Text(
                        order.name_ur ?? "",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// STATUS CHIP
                      _statusChip(order.status, colors),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ORDER DETAILS
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _rowItem("Quantity", "${order.quantity} kg"),
                  _rowItem("Price", "Rs ${order.price}"),
                  _rowItem("Total", "Rs $total", isBold: true),
                  const SizedBox(height: 6),
                  _rowItem("Date",
                      order.created_at.toLocal().toString().split(' ')[0]),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// CANCEL BUTTON
            if (order.status != 'Delivered' && order.status != 'Cancelled')
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _showCancelDialog(context),
                  child: const Text("Cancel Order"),
                ),
              ),

            /// CANCEL REASON
            if (order.cancel_reason != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Reason: ${order.cancel_reason}",
                  style: TextStyle(
                    color: colors.error,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 6),

            // OPTIONAL: EDIT BUTTON
            if (order.status != 'Delivered' && order.status != 'Cancelled')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showEditDialog(context);
                  },
                  child: const Text("Edit Order"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // REUSABLE ROW ITEM
  Widget _rowItem(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// STATUS CHIP (MODERN)
  Widget _statusChip(String status, ColorScheme colors) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        bgColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        break;
      case 'progress':
        bgColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue;
        break;
      case 'pending':
        bgColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange;
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// CANCEL DIALOG
  void _showCancelDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Cancel Order",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: "Enter reason...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.error,
                      ),
                      onPressed: () {
                        if (reasonController.text.isNotEmpty) {
                          controller.cancelOrder(
                              order.id, reasonController.text);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// EDIT ORDER DIALOG
  void _showEditDialog(BuildContext context) {
    final quantityController =
        TextEditingController(text: order.quantity.toString());
    final priceController =
        TextEditingController(text: order.price.toString());

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Order",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Quantity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final newQty =
                            int.tryParse(quantityController.text) ?? order.quantity;
                        final newPrice =
                            double.tryParse(priceController.text) ?? order.price;

                        controller.updateOrder(order.id,
                            quantity: newQty, price: newPrice);

                        Navigator.pop(context);
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}