import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'citas_list_controller.dart';

class CitasListPage extends GetView<CitasListController> {
  const CitasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CitasListController()); // onInit() llama cargar()
    return Scaffold(
      appBar: AppBar(title: const Text('Mis citas')),
      body: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.citas.isEmpty) {
          return const _Empty();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.citas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final r = controller.citas[i];
            final f = DateFormat('dd/MM/yyyy – HH:mm').format(r.startsAt);
            return Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text('Doctor ID: ${r.doctorId}  •  $f'),
                subtitle: Text(
                  'Clínica ${r.clinicId} • Esp. ${r.specialtyId}'
                  '${r.notes == null ? "" : "\n${r.notes}"}',
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Get.toNamed('/citas/nuevo');
          if (created == true) {
            controller.cargar(); // refresca al volver
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.event_busy, size: 56),
              SizedBox(height: 10),
              Text('No tienes citas registradas'),
              SizedBox(height: 4),
              Text('Pulsa “Agregar” para registrar tu próxima cita.'),
            ],
          ),
        ),
      );
}
