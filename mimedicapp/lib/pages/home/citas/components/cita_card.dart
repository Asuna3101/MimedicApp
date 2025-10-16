import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';
import 'package:mimedicapp/widgets/status_badge.dart';

class CitaMedicaCard extends StatelessWidget {
  final AppointmentReminder cita;
  final VoidCallback? onEdit; // placeholder (sin acción aun)

  const CitaMedicaCard({
    super.key,
    required this.cita,
    this.onEdit,
  });

  String _formatFecha(DateTime fecha) {
    final meses = [
      "enero","febrero","marzo","abril","mayo","junio",
      "julio","agosto","septiembre","octubre","noviembre","diciembre"
    ];
    final mes = meses[fecha.month - 1];
    final hora = "${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}";
    return "${fecha.day} de $mes $hora";
  }

    @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // 👇 Borde discreto siempre (sin naranja ni “en 30 min”)
            side: BorderSide(
              color: AppColors.getButtonColor(context).withOpacity(0.35),
              width: 0.8,
            ),
          ),
          elevation: 0.5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cita.specialty.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Badge solo visual
                    StatusBadge(status: cita.status, compact: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(_formatFecha(cita.startsAt),
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 4),
                Text("Dr. / Dra. ${cita.doctor.nombre}",
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(cita.clinic.nombre,
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
                if (cita.notes != null && cita.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(cita.notes!,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black54)),
                ],
              ],
            ),
          ),
        ),
        // Lápiz (placeholder)
        Positioned(
          top: -12,
          right: -8,
          child: IconButton(
            tooltip: 'Editar (pronto)',
            icon: Icon(Icons.edit,
                color: AppColors.getButtonColor(context), size: 26),
            onPressed: onEdit ?? () {},
          ),
        ),
      ],
    );
  }

}
