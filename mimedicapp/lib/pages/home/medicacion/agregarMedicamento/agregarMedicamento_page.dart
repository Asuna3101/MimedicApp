import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/models/unidad.dart';
import 'package:mimedicapp/pages/home/components/header.dart';
import 'package:mimedicapp/pages/home/medicacion/agregarMedicamento/agregarMedicamento_controller.dart';

class AgregarMedicamentoPage extends StatelessWidget {
  const AgregarMedicamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AgregarMedicamentoController());

    return Scaffold(
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: c.formKey,
            child: ListView(
              children: [
                const SizedBox(height: 12),
                const Header(
                  titulo: "Medicación",
                  imagePath: "assets/img/homeIcons/medicamentos.png",
                ),
                const SizedBox(height: 30),

                // 🔹 Autocompletado de nombre
                Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return c.medicamentos
                        .map((m) => m.nombre)
                        .where((nombre) => nombre
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()));
                  },
                  fieldViewBuilder:
                      (context, textCtrl, focusNode, onFieldSubmitted) {
                    textCtrl.addListener(() {
                      c.nombreCtrl.text = textCtrl.text;
                    });
                    return TextFormField(
                      controller: textCtrl,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del medicamento',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Requerido' : null,
                    );
                  },
                  onSelected: (selection) => c.nombreCtrl.text = selection,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: c.dosisCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Dosis'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Requerido' : null,
                ),

                const SizedBox(height: 16),

                // 🔹 Autocompletado de unidad
                Autocomplete<Unidad>(
                  displayStringForOption: (u) => u.nombre,
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Unidad>.empty();
                    }
                    return c.unidades.where((u) => u.nombre
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  fieldViewBuilder:
                      (context, textCtrl, focusNode, onFieldSubmitted) {
                    textCtrl.addListener(() {
                      c.unidadCtrl.text = textCtrl.text;
                    });
                    return TextFormField(
                      controller: textCtrl,
                      focusNode: focusNode,
                      decoration: const InputDecoration(labelText: 'Unidad'),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Requerido' : null,
                    );
                  },
                  onSelected: (Unidad sel) {
                    c.unidadCtrl.text = sel.nombre;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: c.frecuenciaCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Frecuencia (horas)'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Requerido' : null,
                ),

                const SizedBox(height: 24),

                // 🔹 Fecha y hora
                Obx(() => Column(
                      children: [
                        ListTile(
                          title: Text(
                            c.fechaInicio.value != null
                                ? 'Inicio: ${c.fechaInicio.value!.toLocal().toString().split(' ')[0]}'
                                : 'Seleccionar fecha de inicio',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          trailing: const Icon(Icons.calendar_today,
                              color: AppColors.accent),
                          onTap: () => c.seleccionarFecha(esInicio: true),
                        ),
                        ListTile(
                          title: Text(
                            c.horaInicio.value != null
                                ? 'Hora inicio: ${c.horaInicio.value!.format(context)}'
                                : 'Seleccionar hora de inicio (opcional)',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          trailing: const Icon(Icons.access_time,
                              color: AppColors.accent),
                          onTap: () => c.seleccionarHoraInicio(),
                        ),
                        ListTile(
                          title: Text(
                            c.fechaFin.value != null
                                ? 'Fin: ${c.fechaFin.value!.toLocal().toString().split(' ')[0]}'
                                : 'Seleccionar fecha de fin',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          trailing: const Icon(Icons.calendar_today,
                              color: AppColors.accent),
                          onTap: () => c.seleccionarFecha(esInicio: false),
                        ),
                      ],
                    )),

                const SizedBox(height: 24),

                // 🔹 Botón Guardar reactivo
                Obx(() => ElevatedButton.icon(
                      onPressed:
                          c.isFormValid.value ? c.guardar : null, // <- Bloqueado
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.isFormValid.value
                            ? AppColors.accent
                            : AppColors.grey400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontFamily: 'Titulo',
                          fontSize: 18,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
