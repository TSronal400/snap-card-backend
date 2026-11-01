
class TcgdexCard {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String rarity;

  TcgdexCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.rarity,
  });

  factory TcgdexCard.fromJson(Map<String, dynamic> json) {
    final image = json['image']?.toString() ?? '';

    return TcgdexCard(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Carta Pokémon',
      imageUrl: image.isEmpty ? '' : '$image/high.png',
      category: json['category']?.toString() ?? 'Pokémon',
      rarity: json['rarity']?.toString() ?? 'Sin especificar',
    );
  }
}



