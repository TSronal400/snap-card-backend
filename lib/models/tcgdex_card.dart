import 'dart:convert';

class TcgdexCard {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> alternativeImages;
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
    this.alternativeImages = const [],
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

    final List<String> altImages = [];

    if (image.trim().isNotEmpty) {
      String img = image.trim();
      if (!img.endsWith('.png') && !img.endsWith('.jpg')) {
        altImages.add('$img/high.png');
      } else {
        altImages.add(img);
      }
    }

    if (id.contains('-')) {
      final parts = id.split('-');
      final sId = parts[0];
      final lId = parts.sublist(1).join('-');
      altImages.add('https://assets.tcgdex.net/es/$sId/$lId/high.png');
      altImages.add('https://assets.tcgdex.net/en/$sId/$lId/high.png');
    }
    if (id.isNotEmpty) {
      altImages.add('https://assets.tcgdex.net/es/$id/high.png');
    }

    if (setId.isNotEmpty && localId.isNotEmpty) {
      altImages.add('https://images.pokemontcg.io/$setId/${localId}_hires.png');
      altImages.add('https://images.pokemontcg.io/$setId/$localId.png');
    }

    altImages.add('https://product-images.tcgplayer.com/fit-in/400x400/placeholder.jpg');

    final uniqueUrls = altImages.toSet().toList();
    final primaryImage = uniqueUrls.isNotEmpty ? uniqueUrls.first : 'https://product-images.tcgplayer.com/fit-in/400x400/placeholder.jpg';
    final fallbackList = uniqueUrls.length > 1 ? uniqueUrls.sublist(1) : <String>[];

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
      imageUrl: primaryImage,
      alternativeImages: fallbackList,
      category: json['category']?.toString() ?? 'Pokémon',
      rarity: json['rarity']?.toString() ?? 'Sin especificar',
      localId: localId.isEmpty ? (id.contains('-') ? id.split('-').last : '') : localId,
      setId: setId.isEmpty ? (id.contains('-') ? id.split('-').first : '') : setId,
      setName: json['set_name']?.toString() ?? '',
      hp: int.tryParse(json['hp']?.toString() ?? ''),
      types: parsedTypes,
      stage: json['stage']?.toString() ?? '',
      illustrator: json['illustrator']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
