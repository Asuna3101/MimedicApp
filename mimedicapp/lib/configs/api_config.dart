/// Configuración de la API
class ApiConfig {
  /// Se inyecta con: --dart-define=BASE_URL=...
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8002/api/v1', // fallback útil en emulador Android
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
  static const String usersEndpoint = '/users'; // sin / final para evitar dobles //
  static const String currentUserEndpoint = '/users/me';

  // Helper para construir URLs absolutas (evita dobles “//”)
  static String url(String path) {
    final p = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$p';
  }

  // ---------- HEALTH ----------
  static String clinics() => url('/health/clinicas');

  static String clinicSpecialties(int clinicaId) =>
      url('/health/clinicas/$clinicaId/especialidades');

  static String doctors({required int clinicaId, required int especialidadId}) =>
      url('/health/doctores?clinica_id=$clinicaId&especialidad_id=$especialidadId');

  static String availability({required int doctorId, required String fechaIso}) =>
      url('/health/doctores/$doctorId/availability?fecha=$fechaIso');

  // Crear cita (usa baseUrl inyectado)
  static String get createAppointment => url('/health/citas');

  /// Instrucciones rápidas para IP local
  static String getIpInstructions() => '''
Para conectar con tu backend local:

1) Obtén tu IP:
   - Windows: ipconfig
   - macOS/Linux: ifconfig

2) Ejecuta la app con:
   flutter run --dart-define=BASE_URL=http://TU_IP_LOCAL:8002/api/v1

Notas:
- Android Emulator usa 10.0.2.2 en vez de 127.0.0.1
- iOS Simulator puede usar 127.0.0.1
- Dispositivo físico: ambos (PC y móvil) en la misma Wi-Fi.
''';
}
