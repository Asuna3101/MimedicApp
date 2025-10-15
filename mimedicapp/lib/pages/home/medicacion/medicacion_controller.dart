import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
import 'package:mimedicapp/pages/home/medicacion/editarMedicamento/editarMedicamento_controller.dart';
import '../../../models/medicamentoUsuario.dart';
import '../../../services/medicacion_service.dart';

class MedicacionController extends GetxController {
  final MedicacionService _service = MedicacionService();

  final isLoading = false.obs;

  final medicamentosUsuario = <MedicamentoUsuario>[].obs;

  void goToAgregarMedicacion() {
    Get.toNamed(HomeRoutes.agregarMedicamento, id: 1)?.then((result) {
      if (result == true) {
        loadData();
      }
    });
  }

  void goToEditarMedicacion(MedicamentoUsuario medicamento) {
    // Asegurarnos de que el controlador de edición exista e inicializarlo
    final editarCtrl = Get.put(EditarMedicamentoController());
    editarCtrl.initWith(medicamento);

    Get.toNamed(HomeRoutes.editarMedicamento, id: 1, arguments: medicamento)
        ?.then((result) {
      if (result == true) {
        loadData();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final meds = await _service.getMedicamentosUsuario();
      medicamentosUsuario.assignAll(meds);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los datos: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
