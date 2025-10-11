/// Configuración de la API
class ApiConfig {
  /// Inyecta la URL con: --dart-define=BASE_URL=...
  /// Fallback útil para emulador Android: 10.0.2.2 apunta al host
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8002/api/v1',
  );

  // Timeouts y headers
  static const Duration timeout = Duration(seconds: 30);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

// ---------- AUTH ----------
static const String loginEndpoint = '/auth/login';
static const String loginFormEndpoint = '/auth/login';
static const String registerEndpoint = '/auth/register';
// sin slash final para evitar dobles “//”
static const String usersEndpoint = '/users';
static const String currentUserEndpoint = '/users/me';


  // Helper para construir URLs absolutas (normaliza /)
  static String url(String path) {
    final p = path.startsWith('/') ? path : '/$path';
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return '$base$p';
  }

  // ---------- HEALTH ----------
  static String clinics() => url('/health/clinicas');

  static String clinicSpecialties(int clinicaId) =>
      url('/health/clinicas/$clinicaId/especialidades');

  static String doctors({required int clinicaId, required int especialidadId}) =>
      url('/health/doctores?clinica_id=$clinicaId&especialidad_id=$especialidadId');

  static String availability({required int doctorId, required String fechaIso}) =>
      url('/health/doctores/$doctorId/availability?fecha=$fechaIso');

  static String get createAppointment => url('/health/citas');

  /// Instrucciones rápidas para IP local
  static String getIpInstructions() => '''
Para conectar con tu backend local:

1) Obtén tu IP:
   - Windows: ipconfig
   - macOS/Linux: ifconfig

2) Ejecuta la app con (ejemplos):
   - Emulador Android:
     flutter run --dart-define=BASE_URL=http://10.0.2.2:8002/api/v1
   - Dispositivo físico (misma Wi-Fi):
     flutter run --dart-define=BASE_URL=http://TU_IP_LOCAL:8002/api/v1
   - iOS Simulator:
     flutter run --dart-define=BASE_URL=http://127.0.0.1:8002/api/v1

Notas:
- Evita hardcodear IPs en código; usa --dart-define.
- Si usas HTTP en dev, permite tráfico claro en AndroidManifest (usesCleartextTraffic).
''';
}
