// lib/models/appointments/appointment_reminder.dart
class AppointmentReminder {
  final int id;
  final int clinicId;
  final int specialtyId;
  final int doctorId;
  final DateTime startsAt;
  final String? notes;

  AppointmentReminder({
    required this.id,
    required this.clinicId,
    required this.specialtyId,
    required this.doctorId,
    required this.startsAt,
    this.notes,
  });

  factory AppointmentReminder.fromJson(Map<String, dynamic> j) =>
      AppointmentReminder(
        id: j['id'],
        clinicId: j['clinic_id'],
        specialtyId: j['specialty_id'],
        doctorId: j['doctor_id'],
        startsAt: DateTime.parse(j['starts_at']),
        notes: j['notes'],
      );
}
