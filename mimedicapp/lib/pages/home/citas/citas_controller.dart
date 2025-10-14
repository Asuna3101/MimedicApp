import 'package:get/get.dart';
import 'package:mimedicapp/models/cita.dart';

import '../../../services/citas_service.dart';

class CitasController extends GetxController {
  final CitasService _service = CitasService();

  final isLoading = false.obs;

  final citasUsuario = <Cita>[].obs;

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
}