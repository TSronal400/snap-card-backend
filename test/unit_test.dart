import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_card/models/tcgdex_card.dart';
import 'package:snap_card/models/user.dart';
import 'package:snap_card/models/card_item.dart';
import 'package:snap_card/main.dart';
import 'package:snap_card/services/api_service.dart';

void main() {
  group('Pruebas Unitarias e Integrales - Snap Card', () {

    test('1. Validación de Modelos (TcgdexCard, UserModel, CardItem)', () {
      final cardJson = {
        'id': 'base1-4',
        'name': 'Charizard',
        'image': '',
        'category': 'Legendaria',
        'rarity': 'Rara Holo',
      };
      final card = TcgdexCard.fromJson(cardJson);
      expect(card.id, 'base1-4');
      expect(card.imageUrl, 'https://assets.tcgdex.net/es/base1-4/high.png');
      expect(card.alternativeImages, contains('https://assets.tcgdex.net/es/base1/4/high.png'));

      final userJson = {'id': 1, 'name': 'Ronal', 'email': 'ronal@test.com'};
      final user = UserModel.fromJson(userJson);
      expect(user.email, 'ronal@test.com');

      final itemJson = {
        'id': 5,
        'name': 'Pikachu',
        'category': 'Especial',
        'price': 100.0,
        'element_type': 'electrico',
        'description': 'Test',
        'image_url': 'http://test.com/img.png'
      };
      final item = CardItem.fromJson(itemJson);
      expect(item.price, 100.0);
    });

    test('2. Validación de Excepciones y Mensajes (ApiException)', () {
      final ex = ApiException('Error de conexión con el servidor');
      expect(ex.toString(), 'Error de conexión con el servidor');
    });

    test('4. Validación de rutas alternativas y respaldos de imágenes de cartas', () {
      final cardJson = {
        'id': '30th-040',
        'name': 'Pikachu',
        'image': '',
        'set_id': '30th',
        'local_id': '040',
      };
      final card = TcgdexCard.fromJson(cardJson);
      expect(card.id, '30th-040');
      expect(card.imageUrl, isNotEmpty);
      expect(card.alternativeImages, isNotEmpty);
      expect(
        card.alternativeImages.any((url) => url.contains('tcgdex.net') || url.contains('pokemontcg.io')),
        true,
      );
    });

    testWidgets('3. Prueba de Pantallas Principales (Smoke Test - WelcomeScreen)', (WidgetTester tester) async {
      await tester.pumpWidget(const SnapCardApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

  });
}
