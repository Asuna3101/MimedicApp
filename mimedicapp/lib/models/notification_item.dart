import 'package:mimedicapp/models/appointment_reminder.dart';
import 'package:mimedicapp/models/toma.dart';

class NotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final DateTime startsAt;
  final AppointmentStatus? status;
  final bool isDueSoon;
  final String source; // e.g. 'appointment', 'medication'
  final dynamic payload;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startsAt,
    this.status,
    this.isDueSoon = false,
    this.source = 'unknown',
    this.payload,
  });

  factory NotificationItem.fromAppointmentReminder(AppointmentReminder r) => NotificationItem(
    id: r.id,
    title: 'Cita con ${r.doctor.nombre}',
    subtitle: r.notes ?? '-',
    startsAt: r.startsAt,
    status: r.status,
    isDueSoon: r.isDueSoon,
    source: 'appointment',
    payload: r,
  );

  factory NotificationItem.fromToma(Toma t) => NotificationItem(
    id: t.id,
    title: 'Toma: ${t.medicamentoNombre}',
    subtitle: '${t.dosis} ${t.unidad}',
    startsAt: t.adquired.toLocal(),
    status: null,
    isDueSoon: true,
    source: 'toma',
    payload: t,
  );
}
