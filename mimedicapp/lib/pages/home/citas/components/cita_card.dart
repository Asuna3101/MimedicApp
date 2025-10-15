// lib/widgets/cita_medica_card.dart
import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class CitaMedicaCard extends StatelessWidget {
  final AppointmentReminder cita;
  final VoidCallback onEdit;

  const CitaMedicaCard({
    super.key,
    required this.cita,
    required this.onEdit,
  });

  String _formatFecha(DateTime fecha) {
    // Ejemplo: "26 de junio 10:00"
    final meses = [
      "enero",
      "febrero",
      "marzo",
      "abril",
      "mayo",
      "junio",
      "julio",
      "agosto",
      "septiembre",
      "octubre",
      "noviembre",
      "diciembre"
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
        // 🔹 Card principal
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: AppColors.getButtonColor(context),
              width: 0.4,
            ),
          ),
          elevation: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Especialidad
                Text(
                  cita.specialty.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 6),

                // Fecha formateada
                Text(
                  _formatFecha(cita.startsAt),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),

                // Doctor
                Text(
                  "Dr. / Dra. ${cita.doctor.nombre}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),

                // Clínica
                Text(
                  cita.clinic.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),

                // Notas (opcional)
                if (cita.notes != null && cita.notes!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    cita.notes!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // 🔹 Botón editar flotante
        Positioned(
          top: -18,
          right: -18,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
            icon: Icon(
              Icons.edit,
              color: AppColors.getButtonColor(context),
              size: 34,
            ),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}