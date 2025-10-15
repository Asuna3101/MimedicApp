import 'package:get/get.dart';
import 'package:mimedicapp/services/health_service.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class CitasListController extends GetxController {
  CitasListController(this._service);
  final HealthService _service;

  final cargando = false.obs;
  final proximas = <AppointmentReminder>[].obs;
  final historial = <AppointmentReminder>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargar();
  }

  Future<void> cargar() async {
    cargando.value = true;
    try {
      final ups = await _service.getUpcomingReminders();
      final hist = await _service.getHistoryReminders();
      proximas.assignAll(ups);
      historial.assignAll(hist);
    } finally {
      cargando.value = false;
    }
  }

  Future<void> changeStatus(AppointmentReminder r, AppointmentStatus newStatus) async {
    // Optimistic UI: mueve en memoria y si falla, revertimos
    final now = DateTime.now();
    final wasInUpcoming = proximas.any((x) => x.id == r.id);

    AppointmentReminder copy(AppointmentReminder a, AppointmentStatus s) => AppointmentReminder(
      id: a.id,
      startsAt: a.startsAt,
      notes: a.notes,
      clinic: a.clinic,
      specialty: a.specialty,
      doctor: a.doctor,
      status: s,
      isDueSoon: a.isDueSoon,
    );

    // quitar de su lista actual
    proximas.removeWhere((x) => x.id == r.id);
    historial.removeWhere((x) => x.id == r.id);

    // decidir a dónde va con el nuevo estado
    final updated = copy(r, newStatus);
    final goesToUpcoming = (newStatus == AppointmentStatus.pendiente && r.startsAt.isAfter(now));

    if (goesToUpcoming) {
      proximas.add(updated);
      // orden opcional por fecha asc
      proximas.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    } else {
      historial.insert(0, updated); // más reciente arriba
    }
    update();

    try {
      await _service.updateAppointmentStatus(reminderId: r.id, status: newStatus);
    } catch (e) {
      // revertir si falla
      proximas.removeWhere((x) => x.id == r.id);
      historial.removeWhere((x) => x.id == r.id);

      // volver a la lista original
      if (wasInUpcoming) {
        proximas.add(r);
        proximas.sort((a, b) => a.startsAt.compareTo(b.startsAt));
      } else {
        historial.insert(0, r);
      }
      update();
      rethrow;
    }
  }
}
