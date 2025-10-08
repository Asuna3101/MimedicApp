import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
import '../../../../models/medicamentoUsuario.dart';

class MedicacionController extends GetxController {
  void goToAgregarMedicacion() => Get.toNamed(HomeRoutes.agregarMedicamento, id: 1);
  void goToEditarMedicacion(MedicamentoUsuario medicamento) => Get.toNamed(HomeRoutes.editarMedicamento, id: 1);
}