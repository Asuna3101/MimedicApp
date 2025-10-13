import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cita_form_controller.dart';

class CitaFormPage extends GetView<CitaFormController> {
  const CitaFormPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _label('Clínica'),
              Obx(() => DropdownButtonFormField(
                value: controller.clinicaSel.value,
                items: controller.clinicas
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.nombre)))
                    .toList(),
                onChanged: controller.onClinicaChanged,
              )),
              const SizedBox(height: 12),

              _label('Especialidad'),
              Obx(() => DropdownButtonFormField(
                value: controller.especialidadSel.value,
                items: controller.especialidades
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.nombre)))
                    .toList(),
                onChanged: controller.onEspecialidadChanged,
              )),
              const SizedBox(height: 12),

              _label('Médico'),
              Obx(() => DropdownButtonFormField(
                value: controller.doctorSel.value,
                items: controller.doctores
                    .map((d) => DropdownMenuItem(value: d, child: Text(d.nombre)))
                    .toList(),
                onChanged: (d) => controller.doctorSel.value = d,
              )),
              const SizedBox(height: 12),

              _label('Fecha'),
              InkWell(
                onTap: controller.seleccionarFecha,
                child: Obx(() => InputDecorator(
                  decoration: const InputDecoration(filled: true, border: OutlineInputBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(controller.fechaLabel), const Icon(Icons.calendar_today_outlined)],
                  ),
                )),
              ),
              const SizedBox(height: 12),

              _label('Hora'),
              InkWell(
                onTap: controller.seleccionarHora,
                child: Obx(() => InputDecorator(
                  decoration: const InputDecoration(filled: true, border: OutlineInputBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(controller.horaLabel), const Icon(Icons.access_time_outlined)],
                  ),
                )),
              ),
              const SizedBox(height: 12),

              _label('Notas (opcional)'),
              TextField(
                controller: controller.notasCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ej.: llevar resultados previos',
                ),
              ),
              const SizedBox(height: 16),

              Obx(() => ElevatedButton(
                onPressed: controller.cargando.value ? null : controller.guardar,
                child: controller.cargando.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}
