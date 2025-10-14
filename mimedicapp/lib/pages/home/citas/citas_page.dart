import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/citas/components/cita_card.dart';

import '../../../configs/colors.dart';
import '../components/Header.dart';
import 'citas_controller.dart';

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CitasController());

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
                      titulo: "Citas",
                      imagePath: "assets/img/homeIcons/citas.png",
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final created = await Get.toNamed('/citas/nuevo');
                          if (created == true) controller.cargar();
                        }, // colocar ruta a agregar cita medica
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

                  if (controller.citasUsuario.isEmpty) {
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 12, left: 24),
                        child: Text(
                          "Próximas Citas",
                          style: TextStyle(
                            fontFamily: 'Titulo',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      // 🔹 Lista con scroll
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: controller.citasUsuario
                                .map(
                                  (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CitaMedicaCard(
                                  cita: c,
                                  onEdit: () => {},
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
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