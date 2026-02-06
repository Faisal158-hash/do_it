// =======================
// PRODUCT DETAILS POPUP (MODERN)
// =======================

import 'package:flutter/material.dart';
import 'product_model.dart';

void showProductDetails(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ProductDetailsSheet(product: product),
  );
}

// =======================
// DETAILS SHEET WIDGET
// =======================

class _ProductDetailsSheet extends StatefulWidget {
  final Product product;
  const _ProductDetailsSheet({required this.product});

  @override
  State<_ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<_ProductDetailsSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.product.price * quantity;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.85,
      minChildSize: 0.5,
      builder: (_, scrollController) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // =======================
                  // DRAG INDICATOR
                  // =======================
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // =======================
                  // PRODUCT IMAGE
                  // =======================
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        widget.product.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =======================
                  // PRODUCT NAMES
                  // =======================
                  Text(
                    widget.product.nameEn,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.nameUr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =======================
                  // PRICE & QUANTITY CARD
                  // =======================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.shade200,
                      ),
                    ),
                    child: Column(
                      children: [

                        _priceRow(
                          'Price per kg',
                          'Rs ${widget.product.price}',
                        ),

                        const SizedBox(height: 12),

                        // QUANTITY SELECTOR
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Quantity (kg)',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                _qtyButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() => quantity--);
                                    }
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _qtyButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    setState(() => quantity++);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        _priceRow(
                          'Total Price',
                          'Rs $totalPrice',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =======================
                  // PLACE ORDER BUTTON
                  // =======================
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showOrderPlacedMessage(
                          context,
                          widget.product.nameEn,
                          quantity,
                          totalPrice.toInt(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =======================
  // HELPER WIDGETS
  // =======================

  Widget _priceRow(String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight:
                isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight:
                isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green.shade800 : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  void _showOrderPlacedMessage(
    BuildContext context,
    String productName,
    int qty,
    int total,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ Order Placed Successfully',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Product: $productName'),
            Text('Quantity: $qty kg'),
            Text('Total: Rs $total'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
      ),
    );
  }
}
