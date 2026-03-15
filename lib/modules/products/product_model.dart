class Product {
  final String id;
  final String categoryId;
  final String nameEn;
  final String nameUr;
  final String imagePath; // Supabase column: image_url
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
      id: map['id']?.toString() ?? '',
      
      // Map category_id directly for now (we map later in controller)
      categoryId: map['category_id']?.toString() ?? '',

      nameEn: map['name_en']?.toString() ?? '',
      nameUr: map['name_ur']?.toString() ?? '',
      imagePath: map['image_url']?.toString() ?? '',
      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}