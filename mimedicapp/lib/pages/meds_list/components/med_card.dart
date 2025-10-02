import 'package:flutter/material.dart';

import '../../../configs/colors.dart';

class MedicineCard extends StatelessWidget {
  final String nombre;
  final String dosis;
  final VoidCallback onEdit;

  const MedicineCard({
    super.key,
    required this.nombre,
    required this.dosis,
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
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nombre (ajustado al contenido)
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 24),

                Expanded(
                  child: Text(
                    dosis,
                    style: const TextStyle(fontSize: 14, color: AppColors.primary),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Botón editar flotante arriba a la derecha
        Positioned(
          top: -10,
          right: -10,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              // overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            icon: Icon(Icons.edit, color: AppColors.getButtonColor(context), size: 20),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}