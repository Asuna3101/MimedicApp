// lib/pages/home/citas/citas_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/pages/home/citas/components/cita_card.dart';
import 'package:mimedicapp/pages/home/citas/listado_cita_medica/citas_list_controller.dart';
import 'package:mimedicapp/pages/home/components/header.dart';
import 'package:mimedicapp/services/health_service.dart';

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CitasListController(Get.find<HealthService>())); 
    final fmt = DateFormat('dd/MM/yyyy – HH:mm');

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/home/inicio', id: 1);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 🔹 Encabezado con botón "Agregar"
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
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.primary,
                          size: 28,
                        ),
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

              // 🔹 Contenido dinámico (lista / cargando / vacío)
              Expanded(
                child: Obx(() {
                  if (controller.cargando.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  final citas = controller.citas;

                  if (citas.isEmpty) {
                    return const _Empty();
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      // 🔹 Lista con scroll y tarjetas personalizadas
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: citas.map((r) {
                              // final fecha = fmt.format(r.startsAt);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CitaMedicaCard(
                                  cita: r,
                                  onEdit: () async {
                                    // final updated = await Get.toNamed(
                                    //   '/citas/editar',
                                    //   arguments: r,
                                    // );
                                    // if (updated == true) controller.cargar();
                                  },
                                  // extraInfo:
                                  //     'Dr. ${r.doctor.nombre} • ${r.specialty.nombre}\n'
                                  //     'Clínica ${r.clinic.nombre}\n'
                                  //     '$fecha${r.notes == null ? "" : "\n${r.notes}"}',
                                ),
                              );
                            }).toList(),
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

// 🔹 Widget para estado vacío
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_busy, size: 56, color: AppColors.primary),
              SizedBox(height: 10),
              Text(
                'No tienes citas registradas',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Pulsa “Agregar” para registrar tu próxima cita.',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
      );
}