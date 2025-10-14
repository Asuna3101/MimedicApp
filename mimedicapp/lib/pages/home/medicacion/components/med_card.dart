import 'package:flutter/material.dart';
import 'package:mimedicapp/models/medicamentoUsuario.dart';

import '../../../../configs/colors.dart';

class MedicineCard extends StatelessWidget {
  final MedicamentoUsuario medicamento;
  final VoidCallback onEdit;

  const MedicineCard({
    super.key,
    required this.medicamento,
    required this.onEdit,
  });

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
              width: 0.2,
            ),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nombre (ajustado al contenido)
                SizedBox(
                  width: 120,
                  child: Text(
                    medicamento.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                Expanded(
                  child: Text(
                    "${medicamento.dosis} ${medicamento.unidad} cada ${medicamento.frecuenciaHoras} horas",
                    style: const TextStyle(fontSize: 15, color: AppColors.primary),
                    softWrap: true,
                  ),
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
            icon: Icon(Icons.edit, color: AppColors.getButtonColor(context), size: 30),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}