import 'package:get/get.dart';
import 'package:mimedicapp/services/user_service.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService();

  final isLoading = false.obs;
  final nombre = ''.obs;
  final correo = ''.obs;
  final celular = ''.obs;
  final fechaNacimiento = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final user = await _userService.getCurrentUser();
      nombre.value = user.nombre;
      correo.value = user.correo;
      celular.value = user.celular;
      fechaNacimiento.value = user.fechaNacimiento;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el perfil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
