class CardItem {
  final int id;
  final String name;
  final String category;
  final double price;
  final String elementType;
  final String description;
  final String imageUrl;

  CardItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.elementType,
    required this.description,
    required this.imageUrl,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'Común',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      elementType: json['element_type'] as String? ?? 'fuego',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}
