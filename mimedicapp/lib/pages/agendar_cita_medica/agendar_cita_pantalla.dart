import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/models/availability.dart';
import 'agendar_cita_controlador.dart';

class AgendarCitaPantalla extends GetView<AgendarCitaControlador> {
  const AgendarCitaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyecta el controlador una sola vez
    Get.put(AgendarCitaControlador(), permanent: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label('Centro de salud'),
            // SOLO este Dropdown observa lo que necesita
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
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.nombre)))
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
                  onChanged: controller.onDoctorChanged,
                )),
            const SizedBox(height: 12),

            _label('Fecha'),
            InkWell(
              onTap: () => controller.seleccionarFecha(context),
              child: Obx(() => InputDecorator(
                    decoration: _pickerDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.fechaLabel),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 12),

            _label('Horarios'),
            Obx(() => controller.cargando.value
                ? const LinearProgressIndicator()
                : const SizedBox.shrink()),
            const SizedBox(height: 8),

            // Lista de slots reactiva
            Expanded(
              child: Obx(() {
                final slots = controller.slots;
                if (slots.isEmpty) {
                  return const Center(child: Text('Selecciona médico y fecha'));
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: slots.map((s) => _slotChip(s)).toList(),
                );
              }),
            ),

            ElevatedButton(
              onPressed: controller.confirmarCita,
              child: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotChip(Slot s) {
    final ctrl = Get.find<AgendarCitaControlador>();
    final label = '${s.horaInicio.substring(0, 5)} - ${s.horaFin.substring(0, 5)}';

    // Este chip solo observa la selección
    return Obx(() {
      final selected = ctrl.slotSel.value == s;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: s.disponible
            ? (v) => ctrl.slotSel.value = v ? s : null
            : null, // deshabilitado si no disponible
        disabledColor: AppColors.grey200,
        selectedColor: AppColors.accent.withOpacity(0.2),
      );
    });
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      );

  InputDecoration _pickerDecoration() => InputDecoration(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      );
}
