import 'package:get/get.dart';
import 'package:mimedicapp/services/health_service.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

class CitasListController extends GetxController {
  CitasListController(this._service);
  final HealthService _service;

  final citas = <AppointmentReminder>[].obs;
  final cargando = false.obs;

  @override
  void onInit() { 
    super.onInit(); 
    cargar(); 
  }

  Future<void> cargar() async {
    cargando.value = true;
    try { 
      citas.assignAll(await _service.getMyAppointmentReminders()); 
    } finally { 
      cargando.value = false; 
    }
  }
}
