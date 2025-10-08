import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
import '../../../../models/medicamento.dart';

class MedicacionController extends GetxController {
  void goToAgregarMedicacion() => Get.toNamed(HomeRoutes.agregarMedicamento, id: 1);
  void goToEditarMedicacion(Medicamento medicamento) => Get.toNamed(HomeRoutes.editarMedicamento, id: 1);
}