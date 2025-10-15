import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cita_form_controller.dart';
import 'package:mimedicapp/models/doctor.dart'; // <-- Import Doctor model if not already imported

class CitaFormPage extends GetView<CitaFormController> {
  const CitaFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;

    Icon downIcon(bool enabled) => Icon(Icons.keyboard_arrow_down,
        color: enabled ? scheme.secondary : disabledColor);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Obx(() {
            final especialidadEnabled = controller.clinicaSel.value != null;
            final medicoEnabled =
                especialidadEnabled && controller.especialidadSel.value != null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _label(context, 'Clínica'),
                DropdownButtonFormField(
                  isExpanded: true,
                  value: controller.clinicaSel.value,
                  items: controller.clinicas
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.nombre)))
                      .toList(),
                  onChanged: controller.onClinicaChanged,
                  hint: const Text('Selecciona clínica'),
                  decoration: const InputDecoration(),
                  icon: downIcon(true),
                ),
                const SizedBox(height: 12),
                _label(context, 'Especialidad'),
                DropdownButtonFormField(
                  isExpanded: true,
                  value: especialidadEnabled
                      ? controller.especialidadSel.value
                      : null,
                  items: controller.especialidades
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.nombre)))
                      .toList(),
                  onChanged: especialidadEnabled
                      ? controller.onEspecialidadChanged
                      : null, // ← desactiva
                  hint: const Text('Selecciona especialidad'),
                  disabledHint: Text('Selecciona especialidad',
                      style:
                          textTheme.bodyMedium?.copyWith(color: disabledColor)),
                  decoration: InputDecoration(
                      enabled: especialidadEnabled), // ← estilo gris
                  icon: downIcon(especialidadEnabled),
                ),
                const SizedBox(height: 12),
                _label(context, 'Médico'),
                DropdownButtonFormField(
                  isExpanded: true,
                  value: medicoEnabled ? controller.doctorSel.value : null,
                  items: controller.doctores
                      .map((d) =>
                          DropdownMenuItem(value: d, child: Text(d.nombre)))
                      .toList(),
                  onChanged: medicoEnabled
                      ? (d) => controller.doctorSel.value = d as Doctor?
                      : null,
                  hint: const Text('Selecciona médico'),
                  disabledHint: Text('Selecciona médico',
                      style:
                          textTheme.bodyMedium?.copyWith(color: disabledColor)),
                  decoration: InputDecoration(enabled: medicoEnabled),
                  icon: downIcon(medicoEnabled),
                ),
                const SizedBox(height: 12),
                _label(context, 'Fecha'),
                InkWell(
                  onTap: controller.seleccionarFecha,
                  child: InputDecorator(
                    decoration: const InputDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.fechaLabel,
                            style: textTheme.bodyMedium),
                        Icon(Icons.calendar_today_outlined,
                            color: scheme.secondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _label(context, 'Hora'),
                InkWell(
                  onTap: controller.seleccionarHora,
                  child: InputDecorator(
                    decoration: const InputDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.horaLabel, style: textTheme.bodyMedium),
                        Icon(Icons.access_time_outlined,
                            color: scheme.secondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _label(context, 'Notas (opcional)'),
                TextField(
                  controller: controller.notasCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText: 'Ej.: llevar resultados previos'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      controller.cargando.value ? null : controller.guardar,
                  child: controller.cargando.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Guardar'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
}
