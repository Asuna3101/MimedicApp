import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';

class MedicacionController extends GetxController {
  void goToAgregarMedicacion() => Get.toNamed(HomeRoutes.agregarMedicamento, id: 1);
}