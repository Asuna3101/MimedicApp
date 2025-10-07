import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/pages/home/components/header.dart';
import 'package:mimedicapp/pages/home/medicacion/medicacion_controller.dart';

import '../../../models/medicamento.dart';
import 'components/med_card.dart';

class MedicacionPage extends StatelessWidget {
  const MedicacionPage({super.key});

  // Lista hardcoded
  List<Medicamento> get _medicamentos => [
    Medicamento(
      id: 1,
      nombre: 'Paracetamol',
      dosis: 500,
      unidad: 'mg',
      frecuenciaHoras: 8,
      fechaInicio: DateTime.now().subtract(const Duration(days: 2)),
      fechaFin: DateTime.now().add(const Duration(days: 5)),
    ),
    Medicamento(
      id: 2,
      nombre: 'Ibuprofeno',
      dosis: 400,
      unidad: 'mg',
      frecuenciaHoras: 12,
      fechaInicio: DateTime.now().subtract(const Duration(days: 1)),
      fechaFin: DateTime.now().add(const Duration(days: 3)),
    ),
    Medicamento(
      id: 3,
      nombre: 'Amoxicilina',
      dosis: 875,
      unidad: 'mg',
      frecuenciaHoras: 12,
      fechaInicio: DateTime.now(),
      fechaFin: DateTime.now().add(const Duration(days: 7)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicacionController());
    final medicamentos = _medicamentos;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          const Header(titulo: "Medicación", imagePath: "assets/img/homeIcons/medicamentos.png"),
      

          const SizedBox(height: 30),

          // Botón Agregar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                controller.goToAgregarMedicacion();
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

          const SizedBox(height: 30),

          // Lista de medicamentos
          Column(
            children: medicamentos
                .map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MedicineCard(
                medicamento: m,
                onEdit: () {
                  // TODO: acción editar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Editar ${m.nombre}'),
                    ),
                  );
                },
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}