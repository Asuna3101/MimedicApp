import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/clinic.dart';
import 'package:mimedicapp/models/specialty.dart';
import 'package:mimedicapp/models/doctor.dart';
import 'package:mimedicapp/models/availability.dart';
import 'package:mimedicapp/services/api_service.dart'; // <- para el token

class HealthService extends GetxService {
  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    if (auth) {
      final token = await ApiService().getAuthToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<List<Clinic>> getClinics() async {
    final r = await http
        .get(Uri.parse(ApiConfig.clinics()), headers: await _headers())
        .timeout(ApiConfig.timeout);

    if (r.statusCode != 200) {
      throw 'Error obteniendo clínicas (${r.statusCode})';
    }
    final List data = jsonDecode(r.body);
    return data.map((e) => Clinic.fromJson(e)).toList();
  }

  Future<List<Specialty>> getSpecialties(int clinicaId) async {
    final r = await http
        .get(Uri.parse(ApiConfig.clinicSpecialties(clinicaId)),
            headers: await _headers())
        .timeout(ApiConfig.timeout);

    if (r.statusCode != 200) {
      throw 'Error obteniendo especialidades (${r.statusCode})';
    }
    final List data = jsonDecode(r.body);
    return data.map((e) => Specialty.fromJson(e)).toList();
  }

  Future<List<Doctor>> getDoctors(int clinicaId, int especialidadId) async {
    final r = await http
        .get(Uri.parse(ApiConfig.doctors(clinicaId: clinicaId, especialidadId: especialidadId)),
            headers: await _headers())
        .timeout(ApiConfig.timeout);

    if (r.statusCode != 200) {
      throw 'Error obteniendo doctores (${r.statusCode})';
    }
    final List data = jsonDecode(r.body);
    return data.map((e) => Doctor.fromJson(e)).toList();
  }

  Future<Availability> getAvailability(int doctorId, String fechaISO) async {
    final r = await http
        .get(Uri.parse(ApiConfig.availability(doctorId: doctorId, fechaIso: fechaISO)),
            headers: await _headers())
        .timeout(ApiConfig.timeout);

    if (r.statusCode != 200) {
      throw 'Error obteniendo disponibilidad (${r.statusCode})';
    }
    return Availability.fromJson(jsonDecode(r.body));
  }

  Future<void> createAppointment({
    required int doctorId,
    required String fechaISO,   // YYYY-MM-DD
    required String horaInicio, // HH:MM:SS
    required String horaFin,    // HH:MM:SS
  }) async {
    final body = jsonEncode({
      'doctor_id': doctorId,
      'fecha': fechaISO,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    });

    final r = await http
        .post(Uri.parse(ApiConfig.createAppointment),
            headers: await _headers(auth: true), body: body)
        .timeout(ApiConfig.timeout);

    if (r.statusCode == 201) return;
    if (r.statusCode == 409) throw 'Horario ya reservado';
    if (r.statusCode == 400) {
      final msg = _extractMsg(r.body) ?? 'Solicitud inválida';
      throw msg;
    }
    throw 'Error al crear cita (${r.statusCode})';
  }

  String? _extractMsg(String body) {
    try {
      final d = jsonDecode(body);
      if (d is Map && d['detail'] != null) return d['detail'].toString();
    } catch (_) {}
    return null;
  }
}
