import 'package:flutter/material.dart';
import 'package:mimedicapp/models/medicamentoUsuario.dart';

import '../../../../configs/colors.dart';

class MedicineCard extends StatelessWidget {
  final MedicamentoUsuario medicamento;
  final VoidCallback onEdit;
  // Opcional: muestra icono de selección
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;

  const MedicineCard({
    super.key,
    required this.medicamento,
    required this.onEdit,
    this.selectionMode = false,
    this.isSelected = false,
    this.onToggleSelect,
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
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            icon: Icon(Icons.edit, color: AppColors.getButtonColor(context), size: 30),
            onPressed: onEdit,
          ),
        ),

        // Icono de selección (si el modo de selección está activo)
        if (selectionMode)
          Positioned(
            top: -18,
            left: -18,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(2),
              ),
              icon: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? AppColors.primary : AppColors.grey400,
                size: 26,
              ),
              onPressed: onToggleSelect,
            ),
          ),
      ],
    );
  }
}