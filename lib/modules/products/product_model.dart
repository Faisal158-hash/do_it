class Product {
  final String id;
  final String categoryId;
  final String nameEn;
  final String nameUr;
  final String imagePath; // Supabase column: image_url
  final double price;
  final String description; // From "Description" column
  final String stock;       // Stored as "yes"/"no"

  Product({
    required this.id,
    required this.categoryId,
    required this.nameEn,
    required this.nameUr,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.stock,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      categoryId: map['category_id']?.toString() ?? '',
      nameEn: map['name_en']?.toString() ?? '',
      nameUr: map['name_ur']?.toString() ?? '',
      imagePath: map['image_url']?.toString() ?? '',

      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,

      //  FIX: match backend column "Description"
      description: map['Description']?.toString() ?? '',

      //  FIX: handle "yes/no" properly
      stock: map['stock']?.toString().toLowerCase() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name_en': nameEn,
      'name_ur': nameUr,
      'image_url': imagePath,
      'price': price,

      //  match backend column names
      'Description': description,
      'stock': stock,
    };
  }

  //  OPTIONAL: easy UI use
  bool get isAvailable => stock == 'yes';
}