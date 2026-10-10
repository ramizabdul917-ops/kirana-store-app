class ProductVariant {
  final String id;
  final String label; // e.g. "250g", "500g", "1kg", "5kg", "1L"
  double price; // fluctuating daily selling price
  double mrp; // printed MRP for discount calculation

  ProductVariant({
    required this.id,
    required this.label,
    required this.price,
    required this.mrp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'price': price,
      'mrp': mrp,
    };
  }

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      label: json['label'] as String,
      price: (json['price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
    );
  }

  ProductVariant copyWith({
    String? id,
    String? label,
    double? price,
    double? mrp,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      label: label ?? this.label,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
    );
  }
}

class Product {
  final String id;
  final String titleHindi;
  final String titleEnglish;
  final String categoryId;
  final String imageEmoji;
  final String description;
  final List<ProductVariant> variants;
  bool inStock;

  Product({
    required this.id,
    required this.titleHindi,
    required this.titleEnglish,
    required this.categoryId,
    required this.imageEmoji,
    required this.description,
    required this.variants,
    this.inStock = true,
  });

  ProductVariant get defaultVariant => variants.isNotEmpty
      ? variants.first
      : ProductVariant(id: 'def', label: '1 Unit', price: 0, mrp: 0);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleHindi': titleHindi,
      'titleEnglish': titleEnglish,
      'categoryId': categoryId,
      'imageEmoji': imageEmoji,
      'description': description,
      'inStock': inStock,
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      titleHindi: json['titleHindi'] as String,
      titleEnglish: json['titleEnglish'] as String,
      categoryId: json['categoryId'] as String,
      imageEmoji: json['imageEmoji'] as String? ?? '🛒',
      description: json['description'] as String? ?? '',
      inStock: json['inStock'] as bool? ?? true,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Product copyWith({
    String? id,
    String? titleHindi,
    String? titleEnglish,
    String? categoryId,
    String? imageEmoji,
    String? description,
    bool? inStock,
    List<ProductVariant>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      titleHindi: titleHindi ?? this.titleHindi,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      categoryId: categoryId ?? this.categoryId,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      description: description ?? this.description,
      inStock: inStock ?? this.inStock,
      variants: variants ?? this.variants,
    );
  }
}
