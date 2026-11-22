
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
  final double? price;

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
    this.price,
  });

  factory TcgdexCard.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final image = json['image']?.toString() ?? '';
    final setId = json['set_id']?.toString()?.toLowerCase() ?? '';
    final localId = json['local_id']?.toString() ?? '';
    final rawTypes = json['types'];

    String resolvedImage = '';
    if (setId.isNotEmpty && localId.isNotEmpty) {
      resolvedImage = 'https://images.pokemontcg.io/$setId/${localId}_hires.png';
    } else if (image.trim().isNotEmpty) {
      resolvedImage = image.trim();
      if (!resolvedImage.endsWith('.png') && !resolvedImage.endsWith('.jpg')) {
        resolvedImage = '$resolvedImage/high.png';
      }
    } else if (id.isNotEmpty) {
      resolvedImage = 'https://assets.tcgdex.net/es/$id/high.png';
    } else {
      resolvedImage = 'https://product-images.tcgplayer.com/fit-in/400x400/placeholder.jpg';
    }

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
      id: id,
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
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
