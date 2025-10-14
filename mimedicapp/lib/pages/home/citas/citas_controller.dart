import 'package:get/get.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';
import 'package:mimedicapp/models/cita.dart';
import 'package:mimedicapp/services/health_service.dart';

import '../../../services/citas_service.dart';

class CitasController extends GetxController {
  // CitasController(this._serviceHealth);
  final HealthService _serviceHealth = HealthService();

  final CitasService _service = CitasService();

  final isLoading = false.obs;

  final citasUsuario = <Cita>[].obs;

  final cargando = false.obs;

  final citas = <AppointmentReminder>[].obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final citas = await _service.getCitasUsuario();
      citasUsuario.assignAll(citas);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los datos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cargar() async {
    cargando.value = true;
    try { 
      citas.assignAll(await _serviceHealth.getMyAppointmentReminders()); 
    } finally { 
      cargando.value = false; 
    }
  }
}