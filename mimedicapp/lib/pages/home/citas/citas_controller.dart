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
}
