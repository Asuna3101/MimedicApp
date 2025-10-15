import 'package:mimedicapp/components/custom_button.dart';
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
          child: Stack(
            children: [
              Column(
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
                                onEdit: () => controller.goToEditarMedicacion(m),
                                selectionMode: controller.selectionMode.value,
                                isSelected: m.id != null && controller.selectedIds.contains(m.id),
                                onToggleSelect: () => controller.toggleSelect(m),
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

              // // Botón fijo en la parte inferior
              // Positioned(
              //   left: 20,
              //   right: 20,
              //   bottom: 20,
              //   child: Obx(() => ElevatedButton(
              //         onPressed: () => controller.toggleSelectionMode(),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: AppColors.primary,
              //           padding: const EdgeInsets.symmetric(vertical: 16),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           elevation: 6,
              //         ),
              //         child: const Text(
              //           'Seleccionar',
              //           style: TextStyle(
              //             color: AppColors.white,
              //             fontSize: 18,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       )),
              // ),

            //   SizedBox(
            //   width: 200, // Ajusta el ancho del botón para hacerlo más pequeño
            //   child: CustomButton(
            //     title: 'Seleccionar',
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/sign-up');
            //     },
            //   ),
            // ),
            ],
          ),
        ),
      ),
    );
  }
}
