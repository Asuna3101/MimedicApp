import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/api_config.dart';

class ApiService {
  // URL base del backend
  static String get baseUrl => ApiConfig.getBaseUrl();

  // Headers por defecto
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Token de autenticación
  String? _authToken;

  /// Obtener el token de autenticación guardado
  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;

    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    return _authToken;
  }

  /// Guardar el token de autenticación
  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Limpiar el token de autenticación
  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Obtener headers con autenticación
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = Map<String, String>.from(_defaultHeaders);
    final token = await getAuthToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Manejar respuestas HTTP
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return {};
        return json.decode(response.body);
      case 400:
        throw ApiException('Solicitud inválida: ${response.body}');
      case 401:
        throw ApiException('No autorizado - Token inválido o expirado');
      case 403:
        throw ApiException('Acceso denegado');
      case 404:
        throw ApiException('Recurso no encontrado');
      case 422:
        final errorData = json.decode(response.body);
        throw ApiException('Error de validación: ${errorData['detail']}');
      case 500:
        throw ApiException('Error interno del servidor');
      default:
        throw ApiException('Error inesperado: ${response.statusCode}');
    }
  }

  /// Realizar petición GET
  Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Error de conexión - Verifica tu conexión a internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Realizar petición POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getAuthHeaders();
      final url = '$baseUrl$endpoint';

      // Logging para debugging
      print('🚀 POST Request to: $url');
      print('📋 Headers: $headers');
      print('📦 Body: ${json.encode(data)}');
      print('📊 Data keys: ${data.keys.toList()}');
      print('📊 Data values: ${data.values.toList()}');

      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 30));

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException catch (e) {
      print('🔌 Socket Exception: $e');
      throw ApiException(
          'Error de conexión - Verifica tu conexión a internet\nURL: $baseUrl$endpoint');
    } catch (e) {
      print('❌ Unexpected Error: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Realizar petición PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Error de conexión - Verifica tu conexión a internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Realizar petición DELETE
  Future<dynamic> delete(String endpoint) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Error de conexión - Verifica tu conexión a internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Login con correo - Compatible con el backend
  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    final data = {
      'correo': email,
      'password': password,
    };

    final response = await post('/auth/login', data);

    // Guardar el token si el login es exitoso
    if (response['access_token'] != null) {
      await saveAuthToken(response['access_token']);
    }

    return response;
  }

  /// Login con OAuth2 (form data) - Alternativo
  Future<Map<String, dynamic>> loginWithForm(
      String email, String password) async {
    try {
      final headers = Map<String, String>.from(_defaultHeaders);
      headers['Content-Type'] = 'application/x-www-form-urlencoded';

      final body = 'username=$email&password=$password';

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      final responseData = _handleResponse(response);

      // Guardar el token si el login es exitoso
      if (responseData['access_token'] != null) {
        await saveAuthToken(responseData['access_token']);
      }

      return responseData;
    } on SocketException {
      throw ApiException('Error de conexión - Verifica tu conexión a internet');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    await clearAuthToken();
  }
}

/// Excepción personalizada para errores de API
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
