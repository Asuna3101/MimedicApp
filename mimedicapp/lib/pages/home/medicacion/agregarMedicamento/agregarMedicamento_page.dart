import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/components/header.dart';
import 'package:mimedicapp/pages/home/medicacion/agregarMedicamento/agregarMedicamento_controller.dart';

class AgregarMedicamentoPage extends StatelessWidget {
  const AgregarMedicamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AgregarMedicamentoController());
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: c.formKey,
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const Header(titulo: "Medicación", imagePath: "assets/img/homeIcons/medicamentos.png"),
            const SizedBox(height: 30),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty)
                  return const Iterable<String>.empty();
                return ['Paracetamol', 'Ibuprofeno', 'Amoxicilina']
                    .where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder:
                  (context, textFieldController, focusNode, onFieldSubmitted) {
                // Sincroniza solo cuando el usuario escribe
                textFieldController.addListener(() {
                  c.nombreCtrl.text = textFieldController.text;
                });

                return TextFormField(
                  controller: textFieldController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                      labelText: 'Nombre del medicamento'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                );
              },
              onSelected: (String selection) {
                c.nombreCtrl.text = selection;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: c.dosisCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Dosis'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty)
                  return const Iterable<String>.empty();
                return ['mg', 'ml', 'pastilla', 'gotas'].where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder:
                  (context, textFieldController, focusNode, onFieldSubmitted) {
                textFieldController.addListener(() {
                  c.unidadCtrl.text = textFieldController.text;
                });

                return TextFormField(
                  controller: textFieldController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Unidad'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                );
              },
              onSelected: (String selection) {
                c.unidadCtrl.text = selection;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: c.frecuenciaCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Frecuencia (horas)'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 24),
            Obx(() => ListTile(
                  title: Text(
                    c.fechaInicio.value != null
                        ? 'Inicio: ${c.fechaInicio.value!.toLocal().toString().split(' ')[0]}'
                        : 'Seleccionar fecha de inicio',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => c.seleccionarFecha(esInicio: true),
                )),
            Obx(() => ListTile(
                  title: Text(
                    c.fechaFin.value != null
                        ? 'Fin: ${c.fechaFin.value!.toLocal().toString().split(' ')[0]}'
                        : 'Seleccionar fecha de fin',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => c.seleccionarFecha(esInicio: false),
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: c.guardar,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
