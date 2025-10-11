import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';

class MedicacionPage extends StatelessWidget {
  const MedicacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/img/homeIcons/medicamentos.png',
                  height: 70,
                ),
              ),
              const Text(
                'Medicación',
                style: TextStyle(
                  fontFamily: 'Titulo',
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
      

          const SizedBox(height: 30),

          // Botón Agregar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: acción para agregar medicamento
              },
              icon: const Icon(Icons.add, color: AppColors.primary, size: 28),
              label: const Text(
                'Agregar',
                style: TextStyle(
                  fontFamily: 'Titulo',
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                side: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}