import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';
import 'package:mimedicapp/widgets/status_badge.dart';

class CitaMedicaCard extends StatelessWidget {
  final AppointmentReminder cita;
  final VoidCallback onEdit;                 // puedes dejarlo o quitarlo
  final VoidCallback? onChangeStatusTap; 

  const CitaMedicaCard({
    super.key,
    required this.cita,
    required this.onEdit,
    this.onChangeStatusTap,
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
    final dueSoon = cita.isDueSoon;

    Color borderColor() {
      if (dueSoon) return Colors.orange;
      return StatusBadge.color(cita.status, context).withOpacity(0.9);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor(), width: dueSoon ? 1.5 : 1.0),
          ),
          elevation: 1,
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: cita.status, compact: true, onTap: onChangeStatusTap), // 👈 aquí
                    const SizedBox(width: 8),
                    if (dueSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                        child: const Text('En 30 min', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(_formatFecha(cita.startsAt),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text("Dr. / Dra. ${cita.doctor.nombre}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(cita.clinic.nombre,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                if (cita.notes != null && cita.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(cita.notes!, style: const TextStyle(fontSize: 15, color: Colors.black54)),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          top: -12,
          right: -8,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
            tooltip: 'Cambiar estado / Editar',
            icon: Icon(Icons.edit, color: AppColors.getButtonColor(context), size: 28),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}