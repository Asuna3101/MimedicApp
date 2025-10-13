// lib/services/health_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/clinic.dart';
import 'package:mimedicapp/models/specialty.dart';
import 'package:mimedicapp/models/doctor.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class HealthService {
  Future<Map<String, String>> _headers({bool auth = true}) async {
    // Si tienes token, agréguelo aquí
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    // headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  // --- Catálogos ---
  Future<List<Clinic>> getClinics() async {
    final r = await http.get(Uri.parse(ApiConfig.clinics()), headers: await _headers());
    if (r.statusCode != 200) throw 'Error al obtener clínicas';
    final List data = jsonDecode(r.body);
    return data.map((e) => Clinic.fromJson(e)).toList();
  }

  Future<List<Specialty>> getSpecialties(int clinicId) async {
    final r = await http.get(Uri.parse(ApiConfig.specialties(clinicId)), headers: await _headers());
    if (r.statusCode != 200) throw 'Error al obtener especialidades';
    final List data = jsonDecode(r.body);
    return data.map((e) => Specialty.fromJson(e)).toList();
  }

  Future<List<Doctor>> getDoctors(int clinicId, int specialtyId) async {
    final r = await http.get(Uri.parse(ApiConfig.doctors(clinicId, specialtyId)), headers: await _headers());
    if (r.statusCode != 200) throw 'Error al obtener doctores';
    final List data = jsonDecode(r.body);
    return data.map((e) => Doctor.fromJson(e)).toList();
  }

  // --- Recordatorios de cita ---
  Future<AppointmentReminder> createAppointmentReminder({
    required int clinicId,
    required int specialtyId,
    required int doctorId,
    required DateTime startsAt, // solo inicio
    String? notes,
  }) async {
    final body = jsonEncode({
      'clinic_id': clinicId,
      'specialty_id': specialtyId,
      'doctor_id': doctorId,
      'starts_at': startsAt.toIso8601String(),
      'notes': notes,
    });

    final r = await http
        .post(Uri.parse(ApiConfig.reminders()), headers: await _headers(auth: true), body: body)
        .timeout(ApiConfig.timeout);

    if (r.statusCode == 201) {
      return AppointmentReminder.fromJson(jsonDecode(r.body));
    }
    if (r.statusCode == 409) {
      final msg = _extractMsg(r.body) ?? 'Conflicto: cita duplicada o dentro de ±15 min del mismo doctor.';
      throw msg;
    }
    throw 'Error al crear recordatorio (${r.statusCode})';
  }

  Future<List<AppointmentReminder>> getMyAppointmentReminders() async {
    final r = await http
        .get(Uri.parse(ApiConfig.reminders()), headers: await _headers(auth: true))
        .timeout(ApiConfig.timeout);

    if (r.statusCode != 200) throw 'Error al obtener recordatorios (${r.statusCode})';
    final List data = jsonDecode(r.body);
    return data.map((e) => AppointmentReminder.fromJson(e)).toList();
  }

  String? _extractMsg(String body) {
    try {
      final m = jsonDecode(body);
      return m['detail']?.toString();
    } catch (_) {
      return null;
    }
  }
}
