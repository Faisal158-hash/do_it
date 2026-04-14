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
      userId: map['user_id'],
      nameEn: map['name_en'],
      nameUr: map['name_ur'],
      imageUrl: map['image_url'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      stock: map['stock'],
      totalPrice: (map['total_price'] as num).toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}