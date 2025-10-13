import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mimedicapp/models/clinic.dart';
import 'package:mimedicapp/models/specialty.dart';
import 'package:mimedicapp/models/doctor.dart';
import 'package:mimedicapp/services/health_service.dart';

class CitaFormController extends GetxController {
  final _service = Get.find<HealthService>();

  // combos
  final clinicas = <Clinic>[].obs;
  final especialidades = <Specialty>[].obs;
  final doctores = <Doctor>[].obs;

  final clinicaSel = Rxn<Clinic>();
  final especialidadSel = Rxn<Specialty>();
  final doctorSel = Rxn<Doctor>();

  // fecha/hora + notas
  final fecha = Rxn<DateTime>();
  final hora  = Rxn<TimeOfDay>();
  final notasCtrl = TextEditingController();
  final cargando = false.obs;

  String get fechaLabel => fecha.value==null
      ? 'Seleccionar fecha'
      : DateFormat('dd/MM/yyyy').format(fecha.value!);

  String get horaLabel => hora.value==null
      ? 'Seleccionar hora'
      : '${hora.value!.hour.toString().padLeft(2,'0')}:${hora.value!.minute.toString().padLeft(2,'0')}';

  @override
  void onInit() { super.onInit(); _loadClinics(); }

  Future<void> _loadClinics() async {
    try { clinicas.assignAll(await _service.getClinics()); } catch (_) {}
  }

  Future<void> onClinicaChanged(Clinic? c) async {
    clinicaSel.value = c; especialidadSel.value=null; doctorSel.value=null;
    especialidades.clear(); doctores.clear();
    if (c!=null) especialidades.assignAll(await _service.getSpecialties(c.id));
  }

  Future<void> onEspecialidadChanged(Specialty? s) async {
    especialidadSel.value = s; doctorSel.value=null; doctores.clear();
    if (s!=null && clinicaSel.value!=null) {
      doctores.assignAll(await _service.getDoctors(clinicaSel.value!.id, s.id));
    }
  }

  Future<void> seleccionarFecha() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: Get.context!, initialDate: fecha.value??hoy,
      firstDate: hoy.subtract(const Duration(days:1)),
      lastDate: DateTime(hoy.year+1),
    );
    if (picked!=null) fecha.value=picked;
  }

  Future<void> seleccionarHora() async {
    final picked = await showTimePicker(
      context: Get.context!, initialTime: hora.value ?? TimeOfDay.now(),
    );
    if (picked!=null) hora.value=picked;
  }

  Future<void> guardar() async {
    if (cargando.value) return;
    if (clinicaSel.value==null || especialidadSel.value==null ||
        doctorSel.value==null || fecha.value==null || hora.value==null) {
      Get.snackbar('Faltan datos','Selecciona clínica, especialidad, médico, fecha y hora');
      return;
    }

    final startsAt = DateTime(
      fecha.value!.year, fecha.value!.month, fecha.value!.day,
      hora.value!.hour, hora.value!.minute,
    );

    cargando.value = true;
    try {
      await _service.createAppointmentReminder(
        clinicId: clinicaSel.value!.id,
        specialtyId: especialidadSel.value!.id,
        doctorId: doctorSel.value!.id,
        startsAt: startsAt,
        notes: notasCtrl.text.trim().isEmpty ? null : notasCtrl.text.trim(),
      );
      Get.back(result: true); // señal para refrescar listado
      Get.snackbar('Guardado', 'Recordatorio creado');
    } catch (e) {
      Get.snackbar('No se pudo guardar', e.toString()); // 409 dup/±15min
    } finally { cargando.value = false; }
  }

  @override
  void onClose() { notasCtrl.dispose(); super.onClose(); }
}
