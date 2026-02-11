class OrderModel {
  final String productId;
  final int quantity;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  OrderModel({
    required this.productId,
    required this.quantity,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
    };
  }
}
