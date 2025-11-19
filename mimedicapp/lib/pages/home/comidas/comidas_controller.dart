import 'package:get/get.dart';
import 'package:mimedicapp/models/comida.dart';
import 'package:mimedicapp/services/comidas_service.dart';

class ComidasController extends GetxController {
  final ComidasService _service = ComidasService();

  final isLoading = false.obs;
  final comidas = <Comida>[].obs;
  final selectionMode = false.obs;
  final selectedIds = <int>[].obs;

  void toggleSelectionMode() {
    selectionMode.value = !selectionMode.value;
    if (!selectionMode.value) selectedIds.clear();
  }

  void toggleSelect(Comida c) {
    final id = c.id;
    if (id == null) return;
    if (selectedIds.contains(id))
      selectedIds.remove(id);
    else
      selectedIds.add(id);
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final items = await _service.getComidas();
      comidas.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar comidas: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) {
      Get.snackbar('Atención', 'No hay comidas seleccionadas');
      return;
    }
    try {
      isLoading.value = true;
      // eliminar uno a uno
      for (final id in List<int>.from(selectedIds)) {
        await _service.deleteComida(id);
      }
      Get.snackbar('Eliminado', 'Comidas eliminadas correctamente');
      selectionMode.value = false;
      selectedIds.clear();
      await loadData();
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron eliminar: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
