import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mimedicapp/services/comidas_service.dart';
import 'package:mimedicapp/models/comida.dart';

class AgregarComidaController extends GetxController {
  final ComidasService _service = ComidasService();

  final nombreCtrl = TextEditingController();
  final detallesCtrl = TextEditingController();

  final categorias = <Map<String, dynamic>>[].obs;
  final selectedCategoria = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    try {
      final data = await _service.getCategorias();
      categorias.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar categorias: $e');
    }
  }

  Future<void> save() async {
    final nombre = nombreCtrl.text.trim();
    final detalles = detallesCtrl.text.trim();
    if (nombre.isEmpty) {
      Get.snackbar('Validación', 'Nombre requerido');
      return;
    }
    try {
      final c = Comida(
          id: null,
          nombre: nombre,
          detalles: detalles.isEmpty ? null : detalles,
          recomendable: 1,
          createdAt: null);
      await _service.createComida(c, idCategoria: selectedCategoria.value);
      Get.back();
      Get.snackbar('Éxito', 'Comida creada');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear comida: $e');
    }
  }
}
