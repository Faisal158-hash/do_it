class CartModel {
  final String? id;
  final String userId;
  final String nameEn;
  final String nameUr;
  final String imageUrl;
  final double price;
  final int quantity;
  final int stock;
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
    required this.stock,
    required this.totalPrice,
    this.createdAt,
  });

  /// ✅ Added copyWith — helps GetX update UI when quantity/price changes
  CartModel copyWith({
    String? id,
    String? userId,
    String? nameEn,
    String? nameUr,
    String? imageUrl,
    double? price,
    int? quantity,
    int? stock,
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

      // ✅ Fixed bug: correct num casting for price, quantity, stock, totalPrice
      price: ((map['price'] ?? 0) as num).toDouble(),
      quantity: ((map['quantity'] ?? 0) as num).toInt(),
      stock: ((map['stock'] ?? 0) as num).toInt(),
      totalPrice: ((map['total_price'] ?? 0) as num).toDouble(),

      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}