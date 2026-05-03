class CartModel {
  final String? id;
  final String userId;
  final String nameEn;
  final String nameUr;
  final String imageUrl;
  final double price;
  final int quantity;
  final String description; // ✅ ADDED — was missing, exists in Supabase
  final String stock;
  final double totalPrice;
  final DateTime? createdAt;

  CartModel({
    this.id,
    required this.userId,
    required this.nameEn,
    required this.nameUr,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.description, // ✅ ADDED
    required this.stock,
    required this.totalPrice,
    this.createdAt,
  });

  CartModel copyWith({
    String? id,
    String? userId,
    String? nameEn,
    String? nameUr,
    String? imageUrl,
    double? price,
    int? quantity,
    String? description, // ✅ ADDED
    String? stock,
    double? totalPrice,
    DateTime? createdAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description, // ✅ ADDED
      stock: stock ?? this.stock,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name_en': nameEn,
      'name_ur': nameUr,
      'image_url': imageUrl,
      'price': price,
      'quantity': quantity,
      'Description': description, // ✅ ADDED — capital D matches Supabase column
      'stock': stock,
      'total_price': totalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id']?.toString(),
      userId: (map['user_id'] ?? '').toString(),
      nameEn: (map['name_en'] ?? '').toString(),
      nameUr: (map['name_ur'] ?? '').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      price: ((map['price'] ?? 0) as num).toDouble(),
      quantity: ((map['quantity'] ?? 0) as num).toInt(),
      description: (map['Description'] ?? '').toString(), // ✅ ADDED — capital D
      stock: (map['stock'] ?? '') .toString(),
      totalPrice: ((map['total_price'] ?? 0) as num).toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}