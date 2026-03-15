class OrderModel {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String? cancelReason;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    this.cancelReason,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'status': status,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'cancel_reason': cancelReason,
      'date': date.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      productId: map['product_id'],
      productName: map['product_name'] ?? 'Unknown',
      quantity: map['quantity'] ?? 1,
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      status: map['status'] ?? 'Pending',
      customerName: map['customer_name'] ?? '',
      customerPhone: map['customer_phone'] ?? '',
      customerAddress: map['customer_address'] ?? '',
      cancelReason: map['cancel_reason'],
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}