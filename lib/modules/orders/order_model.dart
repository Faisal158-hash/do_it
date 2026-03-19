class OrderModel {
  final String id;
  final String productId;

  /// PRODUCT DATA
  final String productName;
  final String? productNameUr;
  final String imageUrl;

  /// ORDER DATA
  final int quantity;
  final double price;
  final double totalPrice;
  final String status;

  /// CUSTOMER DATA
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  /// OPTIONAL
  final String? cancelReason;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productNameUr,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    this.cancelReason,
    required this.date,
  });

  /// 🔹 TO MAP (SEND TO SUPABASE)
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_name_ur': productNameUr,
      'image_url': imageUrl,
      'quantity': quantity,
      'price': price,
      'total_price': totalPrice,
      'status': status,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'cancel_reason': cancelReason,
      'created_at': date.toIso8601String(),
    };
  }

  /// 🔹 FROM MAP (FETCH FROM SUPABASE)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'].toString(),
      productId: map['product_id'] ?? '',

      productName: map['product_name'] ?? 'Unknown',
      productNameUr: map['product_name_ur'],

      imageUrl: map['image_url'] ??
          'https://via.placeholder.com/150', // fallback image

      quantity: map['quantity'] ?? 1,
      price: double.tryParse(map['price'].toString()) ?? 0.0,

      totalPrice: double.tryParse(map['total_price'].toString()) ??
          ((map['quantity'] ?? 1) *
              (double.tryParse(map['price'].toString()) ?? 0.0)),

      status: (map['status'] ?? 'pending').toString().toLowerCase(),

      customerName: map['customer_name'] ?? '',
      customerPhone: map['customer_phone'] ?? '',
      customerAddress: map['customer_address'] ?? '',

      cancelReason: map['cancel_reason'],

      date: DateTime.tryParse(map['created_at'] ?? '') ??
          DateTime.now(),
    );
  }
}