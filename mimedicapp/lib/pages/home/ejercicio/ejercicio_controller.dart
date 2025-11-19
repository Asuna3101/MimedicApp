import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/pages/container/container_controller.dart';
import 'package:mimedicapp/pages/home/ejercicio/editarEjercicio/editarEjercicio_controller.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
import 'package:mimedicapp/models/ejercicioUsuario.dart';
import 'package:mimedicapp/services/ejercicio_service.dart';

class EjercicioController extends GetxController {
  final EjercicioService _service = EjercicioService();
  final container = Get.find<ContainerController>();

  final isLoading = false.obs;

  final ejerciciosUsuario = <EjercicioUsuario>[].obs;
  // Modo de selección y lista de ids seleccionados
  final selectionMode = false.obs;
  final selectedIds = <int>[].obs;

  void toggleSelectionMode() {
    selectionMode.value = !selectionMode.value;
    if (!selectionMode.value) {
      // limpiar selección al salir del modo
      selectedIds.clear();
    }
  }

  void toggleSelect(EjercicioUsuario ejercicio) {
    final id = ejercicio.id;
    if (id == null) return;
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void goToAgregarEjercicio() {
    Get.toNamed(HomeRoutes.agregarEjercicio, id: 1)?.then((result) {
      if (result == true) {
        loadData();
      }
    });
  }

  void goToEditarEjercicio(EjercicioUsuario ejercicio) {
    final editarCtrl = Get.put(EditarEjercicioUsuarioController());
    editarCtrl.initWith(ejercicio);

    Get.toNamed(HomeRoutes.editarEjercicio, id: 1, arguments: ejercicio)
        ?.then((result) {
      if (result == true) loadData();
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
      final ejs = await _service.getEjerciciosUsuario();
      ejerciciosUsuario.assignAll(ejs);
      container.cargarEjercicios(ejs);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los datos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Eliminar los ejercicios seleccionados.
  /// Muestra confirmación y luego llama al servicio.
  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) {
      Get.snackbar('Atención', 'No hay ejercicios seleccionados');
      return;
    }
    // Esta función sólo ejecuta la eliminación cuando ya se confirmó.
    try {
      isLoading.value = true;
      await _service.deleteEjerciciosUsuario(selectedIds.toList());
      Get.snackbar(
        'Eliminado',
        'Ejercicios eliminados correctamente',
        backgroundColor: Colors.green[100],
        colorText: AppColors.success,
      );
      // Salir del modo selección y recargar
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
