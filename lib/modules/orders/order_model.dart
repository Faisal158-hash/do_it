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

  Map<String, dynamic> toMap({bool forInsert = true}) {
  final map = {
    'name_en': name_en,
    'name_ur': name_ur,
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

  if (!forInsert) {
    map['id'] = id; // include id only for updates or stream mapping
  }

  return map;
}

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    // 🔹 Safe parsing helpers
    String parseString(dynamic value, [String defaultValue = '']) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    double parseDouble(dynamic value, [double defaultValue = 0.0]) {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    final qty = parseInt(map['quantity'], 1);
    final pr = parseDouble(map['price'], 0.0);
    final total = parseDouble(map['total_price'], qty * pr);

    // Status normalization
    String st = parseString(map['status'], 'Pending');
    st = st[0].toUpperCase() + st.substring(1);

    return OrderModel(
      id: parseString(map['id']),
      name_en: parseString(map['name_en'], 'Unknown'),
      name_ur: map['name_ur'] != null ? parseString(map['name_ur']) : null,
      image_url: parseString(
        map['image_url'],
        'https://via.placeholder.com/150', // ✅ default placeholder
      ),
      quantity: qty,
      price: pr,
      total_price: total,
      status: st,
      customer_name: parseString(map['customer_name']),
      customer_phone: parseString(map['customer_phone']),
      customer_address: parseString(map['customer_address']),
      cancel_reason:
          map['cancel_reason'] != null ? parseString(map['cancel_reason']) : null,
      created_at: parseDateTime(map['created_at']),
    );
  }
}