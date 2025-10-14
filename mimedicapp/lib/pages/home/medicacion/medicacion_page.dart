import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/pages/home/components/header.dart';
import 'package:mimedicapp/pages/home/medicacion/medicacion_controller.dart';
import 'components/med_card.dart';

class MedicacionPage extends StatelessWidget {
  const MedicacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicacionController());

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/home/inicio',
            id: 1); // Volver al HomePage dentro del Navigator anidado
        return false; // No salir
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Header(
                      titulo: "Medicación",
                      imagePath: "assets/img/homeIcons/medicamentos.png",
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => controller.goToAgregarMedicacion(),
                        icon: const Icon(Icons.add,
                            color: AppColors.primary, size: 28),
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
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (controller.medicamentosUsuario.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No tienes medicamentos registrados.',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: controller.medicamentosUsuario
                          .map(
                            (m) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: MedicineCard(
                                medicamento: m,
                                onEdit: () =>
                                    controller.goToEditarMedicacion(m),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
