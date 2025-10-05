/// Configuración de la API
class ApiConfig {
  // En desarrollo, usa tu IP local (mismo segmento de red que el móvil/PC)
  // Android Emulator: http://10.0.2.2:8002/api/v1
  // iOS Simulator:    http://127.0.0.1:8002/api/v1
  static const String baseUrl = 'http://192.168.0.8:8002/api/v1';

  // Timeouts y headers
  static const Duration timeout = Duration(seconds: 30);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ---------- AUTH ----------
  static const String loginEndpoint = '/auth/login';
  static const String loginFormEndpoint = '/auth/login';
  static const String usersEndpoint = '/users/';
  static const String currentUserEndpoint = '/users/me';

  // Helper para construir URLs absolutas
  static String url(String path) => '$baseUrl$path';

  // ---------- HEALTH (nuevo) ----------
  // Clínicas
  static String clinics() => url('/health/clinicas');

  // Especialidades de una clínica
  static String clinicSpecialties(int clinicaId) =>
      url('/health/clinicas/$clinicaId/especialidades');

  // Doctores por clínica + especialidad
  static String doctors({required int clinicaId, required int especialidadId}) =>
      url('/health/doctores?clinica_id=$clinicaId&especialidad_id=$especialidadId');

  // Disponibilidad de un doctor para una fecha (YYYY-MM-DD)
  static String availability({required int doctorId, required String fechaIso}) =>
      url('/health/doctores/$doctorId/availability?fecha=$fechaIso');

  // Crear cita
  static const String createAppointment = '$baseUrl/health/citas'; // <-- constante

  /// Instrucciones rápidas para IP local
  static String getIpInstructions() => '''
Para conectar con tu backend local:

1) Obtén tu IP:
   - Windows: ipconfig
   - macOS/Linux: ifconfig

2) Reemplaza arriba baseUrl con: http://TU_IP_LOCAL:8002/api/v1

Notas:
- Android Emulator usa 10.0.2.2 en vez de 127.0.0.1
- iOS Simulator puede usar 127.0.0.1
- Dispositivo físico: ambos (PC y móvil) deben estar en la misma Wi-Fi.
''';
}
