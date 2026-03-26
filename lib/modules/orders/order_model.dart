class OrderModel {
  final String id;

  /// PRODUCT DATA
  final String name_en;
  final String? name_ur;
  final String image_url;

  /// ORDER DATA
  final int quantity;
  final double price;
  final double total_price;
  final String status; // "Pending", "Progress", "Delivered", "Cancelled"

  /// CUSTOMER DATA
  final String customer_name;
  final String customer_phone;
  final String customer_address;

  /// OPTIONAL
  final String? cancel_reason;
  final DateTime created_at;

  OrderModel({
    required this.id,
    required this.name_en,
    required this.name_ur,
    required this.image_url,
    required this.quantity,
    required this.price,
    required this.total_price,
    required this.status,
    required this.customer_name,
    required this.customer_phone,
    required this.customer_address,
    this.cancel_reason,
    required this.created_at,
  });

  /// 🔹 TO MAP (SEND TO SUPABASE)
  Map<String, dynamic> toMap() {
    return {
      'product_name': name_en,
      'product_name_ur': name_ur,
      'image_url': image_url,
      'quantity': quantity,
      'price': price,
      'total_price': total_price,
      'status': status.toLowerCase(),
      'customer_name': customer_name,
      'customer_phone': customer_phone,
      'customer_address': customer_address,
      'cancel_reason': cancel_reason,
      'created_at': created_at.toIso8601String(),
    };
  }

  /// 🔹 FROM MAP (FETCH FROM SUPABASE)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    // Parse quantity safely
    int qty = 1;
    if (map['quantity'] != null) {
      qty = map['quantity'] is int
          ? map['quantity']
          : int.tryParse(map['quantity'].toString()) ?? 1;
    }

    // Parse price safely
    double pr = 0.0;
    if (map['price'] != null) {
      pr = map['price'] is double
          ? map['price']
          : double.tryParse(map['price'].toString()) ?? 0.0;
    }

    // Calculate total price if missing
    double total = 0.0;
    if (map['total_price'] != null) {
      total = double.tryParse(map['total_price'].toString()) ?? (qty * pr);
    } else {
      total = qty * pr;
    }

    // Status normalization
    String st = (map['status'] ?? 'pending').toString().toLowerCase();
    st = st[0].toUpperCase() + st.substring(1); // Capitalize first letter

    // Parse date
    DateTime dt = DateTime.now();
    if (map['created_at'] != null) {
      dt = DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now();
    }

    return OrderModel(
      id: map['id']?.toString() ?? '',
      name_en: map['product_name'] ?? 'Unknown',
      name_ur: map['product_name_ur'],
      image_url: map['image_url'] ??
          'https://via.placeholder.com/150', // fallback image
      quantity: qty,
      price: pr,
      total_price: total,
      status: st,
      customer_name: map['customer_name'] ?? '',
      customer_phone: map['customer_phone'] ?? '',
      customer_address: map['customer_address'] ?? '',
      cancel_reason: map['cancel_reason'],
      created_at: dt,
    );
  }
}