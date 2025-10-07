import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mimedicapp/models/medicamento.dart';

class AgregarMedicamentoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nombreCtrl = TextEditingController();
  final dosisCtrl = TextEditingController();
  final unidadCtrl = TextEditingController();
  final frecuenciaCtrl = TextEditingController();

  final fechaInicio = Rxn<DateTime>();
  final fechaFin = Rxn<DateTime>();

  void seleccionarFecha({required bool esInicio}) async {
    final seleccionada = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (seleccionada != null) {
      if (esInicio) {
        fechaInicio.value = seleccionada;
      } else {
        fechaFin.value = seleccionada;
      }
    }
  }

  void guardar() {
    if (!formKey.currentState!.validate() ||
        fechaInicio.value == null ||
        fechaFin.value == null) {
      Get.snackbar('Campos incompletos', 'Completa todos los campos');
      return;
    }

    final nuevo = Medicamento(
      id:  DateTime.now().millisecondsSinceEpoch,
      nombre: nombreCtrl.text.trim(),
      dosis: int.parse(dosisCtrl.text),
      unidad: unidadCtrl.text.trim(),
      frecuenciaHoras: int.parse(frecuenciaCtrl.text),
      fechaInicio: fechaInicio.value!,
      fechaFin: fechaFin.value!,
    );

    // Guardar (temporal)
    print('Guardado: ${nuevo.toJson()}');
    Get.back(result: nuevo);
  }

  @override
  void onClose() {
    nombreCtrl.dispose();
    dosisCtrl.dispose();
    unidadCtrl.dispose();
    frecuenciaCtrl.dispose();
    super.onClose();
  }
}
