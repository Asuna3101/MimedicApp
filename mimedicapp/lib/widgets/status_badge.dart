import 'package:flutter/material.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;
  final bool compact;
  final VoidCallback? onTap;
  const StatusBadge({super.key, required this.status, this.compact = false, this.onTap});

  static String label(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.asistido: return 'Asistido';
      case AppointmentStatus.noAsistido: return 'No asistido';
      case AppointmentStatus.pendiente: default: return 'Pendiente';
    }
  }

  static Color color(AppointmentStatus s, BuildContext ctx) {
    switch (s) {
      case AppointmentStatus.asistido: return Colors.green;
      case AppointmentStatus.noAsistido: return Colors.redAccent;
      case AppointmentStatus.pendiente: default: return Theme.of(ctx).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = color(status, context);
    final child = Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        border: Border.all(color: c, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label(status),
        style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: compact ? 12 : 13),
      ),
    );

    if (onTap == null) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap, child: child),
    );
  }
}
