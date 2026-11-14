
import 'dart:convert';

class TcgdexCard {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String rarity;
  final String localId;
  final String setId;
  final String setName;
  final int? hp;
  final List<String> types;
  final String stage;
  final String illustrator;

  TcgdexCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.rarity,
    this.localId = '',
    this.setId = '',
    this.setName = '',
    this.hp,
    this.types = const [],
    this.stage = '',
    this.illustrator = '',
  });

  factory TcgdexCard.fromJson(Map<String, dynamic> json) {
    final image = json['image']?.toString() ?? '';
    final rawTypes = json['types'];

    const fallbackImage = 'https://images.pokemontcg.io/base1/4_hires.png';
    final resolvedImage = image.isEmpty
        ? fallbackImage
        : image.startsWith('http')
            ? image
            : '$image/high.png';

    List<String> parsedTypes = [];
    if (rawTypes is List) {
      parsedTypes = rawTypes.map((t) => t.toString()).toList();
    } else if (rawTypes is String && rawTypes.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawTypes);
        if (decoded is List) {
          parsedTypes = decoded.map((t) => t.toString()).toList();
        } else {
          parsedTypes = [rawTypes];
        }
      } catch (_) {
        parsedTypes = rawTypes.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
      }
    }

    return TcgdexCard(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Carta Pokémon',
      imageUrl: resolvedImage,
      category: json['category']?.toString() ?? 'Pokémon',
      rarity: json['rarity']?.toString() ?? 'Sin especificar',
      localId: json['local_id']?.toString() ?? '',
      setId: json['set_id']?.toString() ?? '',
      setName: json['set_name']?.toString() ?? '',
      hp: int.tryParse(json['hp']?.toString() ?? ''),
      types: parsedTypes,
      stage: json['stage']?.toString() ?? '',
      illustrator: json['illustrator']?.toString() ?? '',
    );
  }
}
