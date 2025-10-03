/// Configuración de la API
class ApiConfig {
  // URL base del backend
  // En desarrollo, usa tu IP local. Ejemplo: 'http://192.168.1.100:8001/api/v1'
  // Para el emulador de Android: 'http://10.0.2.2:8001/api/v1'
  // Para iOS Simulator: 'http://127.0.0.1:8001/api/v1'
  static const String baseUrl = 'http://10.0.2.2:8002/api/v1';

  // Para dispositivos físicos, reemplaza con tu IP local:
  // static const String baseUrl = 'http://TU_IP_LOCAL:8000/api/v1';

  // Timeout para las peticiones HTTP
  static const Duration timeout = Duration(seconds: 30);

  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String loginFormEndpoint = '/auth/login';
  static const String usersEndpoint = '/users/';
  static const String currentUserEndpoint = '/users/me';

  /// Obtener la URL base según el entorno
  static String getBaseUrl() {
    // Aquí puedes agregar lógica para diferentes entornos
    // Por ejemplo, verificar si estás en modo debug o release
    return baseUrl;
  }

  /// Instrucciones para configurar la IP
  static String getIpInstructions() {
    return '''
Para conectar con tu backend local:

1. Obtén tu IP local:
   - Windows: Ejecuta 'ipconfig' en cmd
   - macOS/Linux: Ejecuta 'ifconfig' en terminal
   
2. Busca tu dirección IP (ej: 192.168.1.100)

3. Actualiza ApiConfig.baseUrl con:
   'http://TU_IP_LOCAL:8000/api/v1'

4. Asegúrate de que tu backend esté ejecutándose en el puerto 8000

Nota: Para el emulador de Android usa: http://10.0.2.2:8000/api/v1
''';
  }
}
