// lib/services/health_service.dart
import 'package:mimedicapp/services/api_service.dart';
import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/clinic.dart';
import 'package:mimedicapp/models/specialty.dart';
import 'package:mimedicapp/models/doctor.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

/// Capa de dominio para catálogos y recordatorios de cita.
/// Depende de ApiService para autenticación, headers y manejo de errores.
class HealthService {
  HealthService([ApiService? api]) : _api = api ?? ApiService();
  final ApiService _api;

  // ---------- Catálogos ----------
  Future<List<Clinic>> getClinics() async {
    final data = await _api.get(ApiConfig.clinics(), auth: true);
    final list = (data as List).map((e) => Clinic.fromJson(e)).toList();
    return list;
  }

  Future<List<Specialty>> getSpecialties(int clinicId) async {
    final data = await _api.get(ApiConfig.specialties(clinicId), auth: true);
    final list = (data as List).map((e) => Specialty.fromJson(e)).toList();
    return list;
  }

  Future<List<Doctor>> getDoctors(int clinicId, int specialtyId) async {
    final data = await _api.get(ApiConfig.doctors(clinicId, specialtyId), auth: true);
    final list = (data as List).map((e) => Doctor.fromJson(e)).toList();
    return list;
  }

  // ---------- Recordatorios ----------
  Future<AppointmentReminder> createAppointmentReminder({
    required int clinicId,
    required int specialtyId,
    required int doctorId,
    required DateTime startsAt,
    String? notes,
  }) async {
    final payload = <String, dynamic>{
      'clinic_id': clinicId,
      'specialty_id': specialtyId,
      'doctor_id': doctorId,
      // Enviar SIEMPRE en UTC (ISO-8601 con Z)
      'starts_at': startsAt.toUtc().toIso8601String(),
      if (notes != null) 'notes': notes,
    };

    final data = await _api.post(ApiConfig.reminders(), payload, auth: true);
    return AppointmentReminder.fromJson(data as Map<String, dynamic>);
  }

  Future<List<AppointmentReminder>> getMyAppointmentReminders() async {
    final data = await _api.get(ApiConfig.reminders(), auth: true);
    final list = (data as List).map((e) => AppointmentReminder.fromJson(e)).toList();
    return list;
  }
}
