import '../models/usuario.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  /// Crear un nuevo usuario (registro)
  Future<Usuario> createUser(Usuario usuario) async {
    try {
      final userData = {
        'correo': usuario.correo,
        'nombre': usuario.nombre,
        'fecha_nacimiento': usuario.fechaNacimiento
            .toIso8601String()
            .split('T')[0], // Solo fecha
        'celular': usuario.celular,
        'password': usuario.contrasena,
        'is_active': true, // Campo requerido por el backend
      };

      final response = await _apiService.post('/users/', userData);

      // Convertir la respuesta del backend al modelo de Flutter
      return Usuario(
        idUsuario: response['id'],
        nombre: response['nombre'],
        fechaNacimiento: DateTime.parse(response['fecha_nacimiento']),
        celular: response['celular'] ?? '',
        correo: response['correo'],
        contrasena: '', // No devolvemos la contraseña por seguridad
      );
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  /// Obtener información del usuario actual
  Future<Usuario> getCurrentUser() async {
    try {
      final response = await _apiService.get('/users/me');

      return Usuario(
        idUsuario: response['id'],
        nombre: response['nombre'],
        fechaNacimiento: DateTime.parse(response['fecha_nacimiento']),
        celular: response['celular'] ?? '',
        correo: response['correo'],
        contrasena: '', // No devolvemos la contraseña
      );
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }

  /// Obtener usuario por ID
  Future<Usuario> getUserById(int userId) async {
    try {
      final response = await _apiService.get('/users/$userId');

      return Usuario(
        idUsuario: response['id'],
        nombre: response['nombre'],
        fechaNacimiento: DateTime.parse(response['fecha_nacimiento']),
        celular: response['celular'] ?? '',
        correo: response['correo'],
        contrasena: '', // No devolvemos la contraseña
      );
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  /// Actualizar usuario
  Future<Usuario> updateUser(
      int userId, Map<String, dynamic> updateData) async {
    try {
      // Formatear fecha si está presente
      if (updateData['fechaNacimiento'] != null) {
        updateData['fecha_nacimiento'] =
            updateData['fechaNacimiento'].toIso8601String().split('T')[0];
        updateData.remove('fechaNacimiento');
      }

      // Cambiar contrasena por password si está presente
      if (updateData['contrasena'] != null) {
        updateData['password'] = updateData['contrasena'];
        updateData.remove('contrasena');
      }

      final response = await _apiService.put('/users/$userId', updateData);

      return Usuario(
        idUsuario: response['id'],
        nombre: response['nombre'],
        fechaNacimiento: DateTime.parse(response['fecha_nacimiento']),
        celular: response['celular'] ?? '',
        correo: response['correo'],
        contrasena: '', // No devolvemos la contraseña
      );
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  /// Eliminar usuario
  Future<void> deleteUser(int userId) async {
    try {
      await _apiService.delete('/users/$userId');
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  /// Login de usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      return await _apiService.loginWithEmail(email, password);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Logout de usuario
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await _apiService.getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
