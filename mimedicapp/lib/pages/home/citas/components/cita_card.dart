import 'package:flutter/material.dart';
import 'package:mimedicapp/models/cita.dart';

import '../../../../configs/colors.dart';

class CitaMedicaCard extends StatelessWidget {
  final Cita cita;
  final VoidCallback onEdit;

  const CitaMedicaCard({
    super.key,
    required this.cita,
    required this.onEdit,
  });

  String _formatFecha(DateTime fecha) {
    // Ejemplo: "26 de junio 10:00"
    final meses = [
      "enero", "febrero", "marzo", "abril", "mayo", "junio",
      "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
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
        // Card principal
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
            width: double.infinity, // 🔹 ocupa todo el ancho disponible
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Especialidad
                Text(
                  cita.especialidad,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 6),

                // Fecha formateada
                Text(
                  _formatFecha(cita.fecha),
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),

                // Doctor
                Text(
                  "Dr. ${cita.doctor}",
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),

                // Clínica
                Text(
                  cita.clinica,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),

        // Botón editar flotante arriba a la derecha
        Positioned(
          top: -18,
          right: -18,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
            icon: Icon(Icons.edit, color: AppColors.getButtonColor(context), size: 34),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}