import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/card_item.dart';
import '../models/tcgdex_card.dart';

class ApiService {
  // URL de producción en Vercel
  static String baseUrl = 'https://snap-card-backend.vercel.app';

  static const String _tokenKey = 'snapcard_auth_token';
  static const String _userDataKey = 'snapcard_user_data';

  /// Guardar token y datos del usuario en SharedPreferences
  static Future<void> _saveSession(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, auth.accessToken);
    await prefs.setString(_userDataKey, jsonEncode(auth.user.toJson()));
  }

  /// Obtener el token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Obtener el usuario guardado localmente
  static Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userDataKey);

    if (userJson == null) return null;

    try {
      return UserModel.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  /// Cerrar sesión y eliminar token guardado
  static Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (_) {}
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }

  /// Registro de usuario (POST /auth/register)
  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 201 && data is Map<String, dynamic>) {
        final auth = AuthResponse.fromJson(data);
        await _saveSession(auth);
        return auth;
      } else {
        final detail = data is Map && data.containsKey('detail')
            ? data['detail'].toString()
            : 'Error en el servidor (${response.statusCode})';

        throw ApiException(detail);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('No se pudo conectar con el servidor ($e)');
    }
  }

  /// Inicio de sesión (POST /auth/login)
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        final auth = AuthResponse.fromJson(data);
        await _saveSession(auth);
        return auth;
      } else {
        final detail = data is Map && data.containsKey('detail')
            ? data['detail'].toString()
            : response.statusCode == 401
                ? 'Correo o contraseña incorrectos'
                : 'Error en el servidor (${response.statusCode})';

        throw ApiException(detail);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('No se pudo conectar con el servidor ($e)');
    }
  }

  /// Obtener perfil del usuario actual (GET /me)
  static Future<UserModel> getProfile() async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final user = UserModel.fromJson(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _userDataKey,
        jsonEncode(user.toJson()),
      );

      return user;
    } else {
      throw ApiException('Sesión expirada o no autorizada');
    }
  }

  /// Actualizar perfil del usuario (PUT /me)
  static Future<UserModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(
        data as Map<String, dynamic>,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _userDataKey,
        jsonEncode(user.toJson()),
      );

      return user;
    } else {
      final detail = data is Map && data.containsKey('detail')
          ? data['detail'].toString()
          : 'Error al actualizar el perfil';

      throw ApiException(detail);
    }
  }

  /// Buscar cartas por nombre o categoría (GET /cards/search)
  static Future<List<CardItem>> searchCards({
    String query = '',
    String? category,
  }) async {
    final queryParams = <String, String>{};

    if (query.isNotEmpty) {
      queryParams['q'] = query;
    }

    if (category != null &&
        category.isNotEmpty &&
        category != 'Todas') {
      queryParams['category'] = category;
    }

    final uri = Uri.parse('$baseUrl/cards/search').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;

      return list
          .map((item) => CardItem.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    } else {
      throw ApiException(
        'Error al buscar cartas en la base de datos',
      );
    }
  }

  /// Buscar cartas directamente en TCGdex
  static Future<List<TcgdexCard>> searchTcgdexCards(
    String query,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/cards/tcgdex/search',
    ).replace(
      queryParameters: {'q': query.trim()},
    );

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;

      return list
          .map((item) => TcgdexCard.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    } else {
      throw ApiException('Error al buscar cartas en TCGdex');
    }
  }

  /// Obtener categorías únicas de cartas
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body) as List;

        return list.map((item) => item.toString()).toList();
      }
    } catch (_) {}

    return ['Legendaria', 'Épica', 'Rara', 'Especial'];
  }

  /// Consultar al Asistente IA (POST /ai/chat)
  static Future<String> askAI(String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message.trim()}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['reply'] as String? ??
          'No pude procesar tu consulta';
    } else {
      throw ApiException('Error al consultar al asistente IA');
    }
  }

  /// Enviar ticket de soporte (POST /support/ticket)
  static Future<void> submitSupportTicket(String message) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/support/ticket'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'message': message.trim()}),
    );

    if (response.statusCode != 201) {
      throw ApiException('Error al enviar mensaje de soporte');
    }
  }

  /// Obtener colección de cartas del usuario (GET /collection)
  static Future<List<CardItem>> getUserCollection() async {
    final token = await getToken();

    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/collection'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;

      return list
          .map((item) => CardItem.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    } else {
      return [];
    }
  }

  /// Añadir carta a la colección del usuario (POST /collection/add)
  static Future<String> addCardToCollection(int cardId) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/collection/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'card_id': cardId}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 ||
        response.statusCode == 200) {
      return data['message']?.toString() ??
          'Carta añadida con éxito';
    } else {
      throw ApiException(
        data['detail']?.toString() ??
            'Error al añadir carta',
      );
    }
  }

  /// Eliminar carta de la colección del usuario
  static Future<String> removeCardFromCollection(
    int cardId,
  ) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/collection/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message']?.toString() ??
          'Carta eliminada con éxito';
    } else {
      throw ApiException(
        data['detail']?.toString() ??
            'Error al eliminar carta',
      );
    }
  }

  /// Obtener colección personal de cartas TCGdex
  static Future<List<TcgdexCard>> getTcgdexCollection() async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/collection/tcgdex'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;

      return list
          .map((item) => TcgdexCard.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    }

    throw ApiException(
      'Error al obtener tu colección TCGdex',
    );
  }

  /// Enviar una fotografía a Gemini para reconocer una carta Pokémon.
  static Future<Map<String, dynamic>> scanPokemonCard(
    String imagePath,
  ) async {
    final token = await getToken();

    final extension = imagePath.toLowerCase();

    final MediaType contentType;

    if (extension.endsWith('.png')) {
      contentType = MediaType('image', 'png');
    } else if (extension.endsWith('.webp')) {
      contentType = MediaType('image', 'webp');
    } else {
      contentType = MediaType('image', 'jpeg');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/ai/scan'),
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: contentType,
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw ApiException(
      data is Map
          ? data['detail']?.toString() ??
              'Error al reconocer la carta'
          : 'Error al reconocer la carta',
    );
  }

  /// Añadir carta TCGdex a la colección.
  /// Se conserva para no romper conexiones existentes.
  static Future<String> addTcgdexCardToCollection(
    String cardId,
  ) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/collection/tcgdex/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'card_id': cardId}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return data['message']?.toString() ??
          'Carta añadida con éxito';
    }

    throw ApiException(
      data['detail']?.toString() ??
          'Error al añadir carta',
    );
  }

  /// Eliminar carta TCGdex de la colección
  static Future<String> removeTcgdexCardFromCollection(
    String cardId,
  ) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/collection/tcgdex/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message']?.toString() ??
          'Carta eliminada con éxito';
    }

    throw ApiException(
      data['detail']?.toString() ??
          'Error al eliminar carta',
    );
  }

  // ==========================================
  // CARTAS DESEADAS (TCGdex)
  // ==========================================

  /// Obtener cartas deseadas del usuario
  /// GET /collection/wishlist
  static Future<List<TcgdexCard>> getTcgdexWishlist() async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/collection/wishlist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data as List;

      return list
          .map((item) => TcgdexCard.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    }

    throw ApiException(
      data is Map
          ? data['detail']?.toString() ??
              'Error al obtener cartas deseadas'
          : 'Error al obtener cartas deseadas',
    );
  }

  /// Añadir carta TCGdex a Cartas deseadas
  /// POST /collection/wishlist/add
  static Future<String> addTcgdexCardToWishlist(
    String cardId,
  ) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/collection/wishlist/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'card_id': cardId}),
    );

    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return data is Map
          ? data['message']?.toString() ??
              '¡Carta añadida a Cartas deseadas!'
          : '¡Carta añadida a Cartas deseadas!';
    }

    String errorMessage = 'Error al guardar carta deseada';

    if (data is Map) {
      errorMessage =
          data['detail']?.toString() ?? errorMessage;
    } else if (response.body.isNotEmpty) {
      errorMessage = response.body;
    }

    throw ApiException(
      'Error ${response.statusCode}: $errorMessage',
    );
  }

  /// Eliminar carta de Cartas deseadas
  /// DELETE /collection/wishlist/{cardId}
  static Future<String> removeTcgdexCardFromWishlist(
    String cardId,
  ) async {
    final token = await getToken();

    if (token == null) {
      throw ApiException('No hay sesión activa');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/collection/wishlist/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message']?.toString() ??
          'Carta eliminada de Cartas deseadas';
    }

    throw ApiException(
      data is Map
          ? data['detail']?.toString() ??
              'Error al eliminar carta deseada'
          : 'Error al eliminar carta deseada',
    );
  }

  /// Obtener información de la app (GET /app/about)
  static Future<Map<String, dynamic>> getAppInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/app/about'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}

    return {
      'app_name': 'SNAP CARD',
      'version': '1.0.0+1',
      'description':
          'Aplicación profesional para coleccionistas de cartas TCG.',
      'developer': 'Equipo Snap Card & Ronal',
    };
  }

  /// Guardar foto de perfil localmente en SharedPreferences
  static Future<void> saveUserAvatar(int userId, String base64Image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('snapcard_avatar_$userId', base64Image);
  }

  /// Obtener foto de perfil localmente de SharedPreferences
  static Future<String?> getUserAvatar(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('snapcard_avatar_$userId');
  }

  /// Eliminar foto de perfil localmente
  static Future<void> removeUserAvatar(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('snapcard_avatar_$userId');
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
