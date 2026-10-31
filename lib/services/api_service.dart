import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/card_item.dart';

class ApiService {
  // URL de producción en Vercel
  static String baseUrl = 'https://snap-card-amlm.vercel.app';

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
      return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
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
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final auth = AuthResponse.fromJson(data as Map<String, dynamic>);
      await _saveSession(auth);
      return auth;
    } else {
      final detail = data is Map && data.containsKey('detail')
          ? data['detail'].toString()
          : 'Error al registrar la cuenta';
      throw ApiException(detail);
    }
  }

  /// Inicio de sesión (POST /auth/login)
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim().toLowerCase(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final auth = AuthResponse.fromJson(data as Map<String, dynamic>);
      await _saveSession(auth);
      return auth;
    } else {
      final detail = data is Map && data.containsKey('detail')
          ? data['detail'].toString()
          : 'Correo o contraseña incorrectos';
      throw ApiException(detail);
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
      await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
      return user;
    } else {
      throw ApiException('Sesión expirada o no autorizada');
    }
  }

  /// Actualizar perfil del usuario (PUT /me)
  static Future<UserModel> updateProfile({required String name, required String email}) async {
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
      final user = UserModel.fromJson(data as Map<String, dynamic>);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
      return user;
    } else {
      final detail = data is Map && data.containsKey('detail')
          ? data['detail'].toString()
          : 'Error al actualizar el perfil';
      throw ApiException(detail);
    }
  }

  /// Buscar cartas por nombre o categoría (GET /cards/search)
  static Future<List<CardItem>> searchCards({String query = '', String? category}) async {
    final queryParams = <String, String>{};
    if (query.isNotEmpty) queryParams['q'] = query;
    if (category != null && category.isNotEmpty && category != 'Todas') {
      queryParams['category'] = category;
    }

    final uri = Uri.parse('$baseUrl/cards/search').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body) as List;
      return list.map((item) => CardItem.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw ApiException('Error al buscar cartas en la base de datos');
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
      return data['reply'] as String? ?? 'No pude procesar tu consulta';
    } else {
      throw ApiException('Error al consultar al asistente IA');
    }
  }

  /// Enviar ticket de soporte (POST /support/ticket)
  static Future<void> submitSupportTicket(String message) async {
    final token = await getToken();
    if (token == null) throw ApiException('No hay sesión activa');

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
      return list.map((item) => CardItem.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      return [];
    }
  }

  /// Añadir carta a la colección del usuario (POST /collection/add)
  static Future<String> addCardToCollection(int cardId) async {
    final token = await getToken();
    if (token == null) throw ApiException('No hay sesión activa');

    final response = await http.post(
      Uri.parse('$baseUrl/collection/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'card_id': cardId}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return data['message']?.toString() ?? 'Carta añadida con éxito';
    } else {
      throw ApiException(data['detail']?.toString() ?? 'Error al añadir carta');
    }
  }

  /// Eliminar carta de la colección del usuario (DELETE /collection/{cardId})
  static Future<String> removeCardFromCollection(int cardId) async {
    final token = await getToken();
    if (token == null) throw ApiException('No hay sesión activa');

    final response = await http.delete(
      Uri.parse('$baseUrl/collection/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message']?.toString() ?? 'Carta eliminada con éxito';
    } else {
      throw ApiException(data['detail']?.toString() ?? 'Error al eliminar carta');
    }
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
      'description': 'Aplicación profesional para coleccionistas de cartas TCG.',
      'developer': 'Equipo Snap Card & Ronal',
    };
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
