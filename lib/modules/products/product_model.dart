class Product {
  final String id;
  final String categoryId;
  final String nameEn;
  final String nameUr;
  final String imagePath; // now holds NETWORK URL
  final double price;

  Product({
    required this.id,
    required this.categoryId,
    required this.nameEn,
    required this.nameUr,
    required this.imagePath,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      categoryId: map['category_id'],
      nameEn: map['name_en'],
      nameUr: map['name_ur'],
      imagePath: map['image_url'],
      price: double.parse(map['price'].toString()),
    );
  }
}
