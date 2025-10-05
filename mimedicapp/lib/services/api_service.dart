import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mimedicapp/configs/api_config.dart';

/// Servicio HTTP base (login, headers con token, métodos GET/POST/PUT/DELETE).
/// - Guarda/lee el JWT en SharedPreferences bajo la clave `auth_token`.
/// - Usa los endpoints definidos en `ApiConfig`.
class ApiService {
  // --------------- Singleton ---------------
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --------------- Estado / Token ---------------
  String? _authToken; // cacheado en memoria

  /// Devuelve la URL absoluta combinando base + endpoint relativo
  String _abs(String endpoint) {
    // Si el endpoint ya es absoluto, lo regresamos tal cual
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    return '${ApiConfig.baseUrl}$endpoint';
  }

  /// Lee el token del cache o de SharedPreferences
  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    return _authToken;
    }

  /// Persiste el token
  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Borra el token
  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // --------------- Headers ---------------
  Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    if (withAuth) {
      final token = await getAuthToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // --------------- Manejo de respuestas ---------------
  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    final body = response.body;

    // Intenta parsear JSON si hay body
    dynamic jsonBody;
    if (body.isNotEmpty) {
      try {
        jsonBody = json.decode(body);
      } catch (_) {
        // Si no es JSON y fue 200/201, devuelve string
        if (status == 200 || status == 201) return body;
      }
    }

    switch (status) {
      case 200:
      case 201:
        return jsonBody ?? {};
      case 400:
        throw ApiException(_extractDetail(jsonBody) ?? 'Solicitud inválida');
      case 401:
        throw ApiException('No autorizado - Token inválido o expirado');
      case 403:
        throw ApiException('Acceso denegado');
      case 404:
        throw ApiException('Recurso no encontrado');
      case 409:
        throw ApiException(_extractDetail(jsonBody) ?? 'Conflicto: recurso en uso');
      case 422:
        throw ApiException(_extractDetail(jsonBody) ?? 'Error de validación');
      case 500:
        throw ApiException('Error interno del servidor');
      default:
        throw ApiException('Error inesperado: $status');
    }
  }

  String? _extractDetail(dynamic data) {
    try {
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
    } catch (_) {}
    return null;
  }

  // --------------- Métodos HTTP genéricos ---------------
  Future<dynamic> get(String endpoint, {bool auth = true}) async {
    try {
      final r = await http
          .get(
            Uri.parse(_abs(endpoint)),
            headers: await _headers(withAuth: auth),
          )
          .timeout(ApiConfig.timeout);
      return _handleResponse(r);
    } on SocketException {
      throw ApiException('Sin conexión. Verifica tu internet.');
    } on HttpException catch (e) {
      throw ApiException('HTTP error: $e');
    } on FormatException {
      throw ApiException('Respuesta no válida del servidor');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data, {bool auth = true}) async {
    try {
      final url = _abs(endpoint);
      final r = await http
          .post(
            Uri.parse(url),
            headers: await _headers(withAuth: auth),
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(r);
    } on SocketException {
      throw ApiException('Sin conexión. Verifica tu internet.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data, {bool auth = true}) async {
    try {
      final r = await http
          .put(
            Uri.parse(_abs(endpoint)),
            headers: await _headers(withAuth: auth),
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(r);
    } on SocketException {
      throw ApiException('Sin conexión. Verifica tu internet.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {bool auth = true}) async {
    try {
      final r = await http
          .delete(
            Uri.parse(_abs(endpoint)),
            headers: await _headers(withAuth: auth),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(r);
    } on SocketException {
      throw ApiException('Sin conexión. Verifica tu internet.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  // --------------- Login / Logout ---------------
  /// Login JSON: { correo, password } → { access_token, token_type }
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    final payload = {'correo': email, 'password': password};

    final resp = await post(ApiConfig.loginEndpoint, payload, auth: false);

    final token = resp['access_token'];
    if (token is String && token.isNotEmpty) {
      await saveAuthToken(token);
    }
    return resp is Map<String, dynamic> ? resp : <String, dynamic>{};
  }

  /// Login (form-url-encoded). Útil si tu backend expone esa variante.
  Future<Map<String, dynamic>> loginWithForm(String email, String password) async {
    try {
      final headers = Map<String, String>.from(ApiConfig.defaultHeaders)
        ..['Content-Type'] = 'application/x-www-form-urlencoded';

      final body = 'username=$email&password=$password';
      final r = await http
          .post(
            Uri.parse(_abs(ApiConfig.loginFormEndpoint)),
            headers: headers,
            body: body,
          )
          .timeout(ApiConfig.timeout);

      final resp = _handleResponse(r);
      final token = (resp is Map<String, dynamic>) ? resp['access_token'] : null;
      if (token is String && token.isNotEmpty) {
        await saveAuthToken(token);
      }
      return resp is Map<String, dynamic> ? resp : <String, dynamic>{};
    } on SocketException {
      throw ApiException('Sin conexión. Verifica tu internet.');
    }
  }

  /// Cierra sesión local (borra token)
  Future<void> logout() async => clearAuthToken();
}

/// Excepción propia para los errores de API
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}
