class CartModel {
  final String productId;
  final int quantity;

  CartModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'product_id': productId, 'quantity': quantity};
  }
}
