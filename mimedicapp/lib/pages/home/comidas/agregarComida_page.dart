import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/comidas/agregarComida_controller.dart';
import 'package:mimedicapp/components/custom_button.dart';

class AgregarComidaPage extends StatelessWidget {
  const AgregarComidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AgregarComidaController());
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Comida')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.detallesCtrl,
              decoration: const InputDecoration(labelText: 'Detalles'),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final cats = controller.categorias;
              return DropdownButtonFormField<int>(
                value: controller.selectedCategoria.value,
                items: cats
                    .map((c) => DropdownMenuItem<int>(
                          value: c['id'] as int,
                          child: Text(c['nombre'] as String),
                        ))
                    .toList(),
                onChanged: (v) => controller.selectedCategoria.value = v,
                decoration: const InputDecoration(labelText: 'Categoria'),
              );
            }),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Guardar',
              onPressed: () async {
                await controller.save();
              },
            ),
          ],
        ),
      ),
    );
  }
}
