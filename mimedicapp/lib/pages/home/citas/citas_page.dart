import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/pages/home/citas/components/cita_card.dart';
import 'package:mimedicapp/pages/home/citas/components/change_status_sheet.dart';
import 'package:mimedicapp/pages/home/citas/citas_controller.dart';
import 'package:mimedicapp/pages/home/components/header.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
import 'package:mimedicapp/services/health_service.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  void _openChangeStatusSheet(
    BuildContext context,
    CitasListController controller,
    AppointmentReminder r,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ChangeStatusSheet(
        current: r.status,
        onConfirm: (newStatus) async {
          try {
            await controller.changeStatus(r, newStatus);
            final msg = switch (newStatus) {
              AppointmentStatus.pendiente => 'Pendiente',
              AppointmentStatus.asistido => 'Asistido',
              AppointmentStatus.noAsistido => 'No asistido',
            };
            Get.snackbar(
              'Estado actualizado',
              'La cita fue marcada como $msg',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          } catch (e) {
            Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CitasListController(Get.find<HealthService>()));

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/home/inicio', id: 1);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Encabezado + agregar
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
                          final created = await Get.toNamed(HomeRoutes.agregarCita, id: 1);
                          if (created == true) controller.cargar();
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: Obx(() {
                  if (controller.cargando.value) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  final proximas = controller.proximas;
                  final historial = controller.historial;

                  if (proximas.isEmpty && historial.isEmpty) {
                    return const _Empty();
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (proximas.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Text(
                              "Próximas Citas",
                              style: TextStyle(
                                fontFamily: 'Titulo',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          ...proximas.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CitaMedicaCard(
                                cita: r,
                                onEdit: () => _openChangeStatusSheet(context, controller, r),
                                onChangeStatusTap: () =>
                                    _openChangeStatusSheet(context, controller, r),
                              ),
                            ),
                          ),
                        ],

                        // Historial (desplegable)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ExpansionTile(
                            title: const Text(
                              'Historial de Citas',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            childrenPadding: const EdgeInsets.only(bottom: 12),
                            initiallyExpanded: false,
                            children: [
                              if (historial.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Aún no hay historial'),
                                )
                              else
                                ...historial.map(
                                  (r) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                                    child: CitaMedicaCard(
                                      cita: r,
                                      onEdit: () => _openChangeStatusSheet(context, controller, r),
                                      onChangeStatusTap: () =>
                                          _openChangeStatusSheet(context, controller, r),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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
                style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w500),
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
