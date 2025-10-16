// lib/pages/home/citas/citas_controller.dart
import 'package:get/get.dart';
import 'package:mimedicapp/services/health_service.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class CitasListController extends GetxController {
  CitasListController(this._service);
  final HealthService _service;

  final cargando = false.obs;
  final proximas = <AppointmentReminder>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargar();
  }

  Future<void> cargar() async {
    cargando.value = true;
    try {
      final ups = await _service.getUpcomingReminders();
      proximas
        ..assignAll(ups)
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    } finally {
      cargando.value = false;
    }
  }

  Future<void> changeStatus(AppointmentReminder r, AppointmentStatus newStatus) async {
    final idx = proximas.indexWhere((x) => x.id == r.id);
    if (idx == -1) return;

    // Optimistic update: decide efecto en UI
    final removeFromUpcoming = (newStatus != AppointmentStatus.pendiente);

    // Aplica cambios visuales
    if (removeFromUpcoming) {
      final removed = proximas.removeAt(idx);
      update();

      try {
        await _service.updateAppointmentStatus(reminderId: r.id, status: newStatus);
      } catch (e) {
        // Revertir si falla
        proximas.insert(idx, removed);
        update();
        rethrow;
      }
    } else {
      // Cambiar a pendiente: no removemos; solo mandamos al back
      try {
        await _service.updateAppointmentStatus(reminderId: r.id, status: newStatus);
      } catch (e) {
        rethrow;
      }
    }
  }
}
