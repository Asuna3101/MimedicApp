import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mimedicapp/models/clinic.dart';
import 'package:mimedicapp/models/specialty.dart';
import 'package:mimedicapp/models/doctor.dart';
import 'package:mimedicapp/models/availability.dart';
import 'package:mimedicapp/services/health_service.dart';

class AgendarCitaControlador extends GetxController {
  final _service = Get.put(HealthService(), permanent: true);

  // combos
  final clinicas = <Clinic>[].obs;
  final especialidades = <Specialty>[].obs;
  final doctores = <Doctor>[].obs;

  // selección
  final clinicaSel = Rxn<Clinic>();
  final especialidadSel = Rxn<Specialty>();
  final doctorSel = Rxn<Doctor>();

  // fecha y slots
  final fecha = Rxn<DateTime>();
  final slots = <Slot>[].obs;
  final slotSel = Rxn<Slot>();

  final cargando = false.obs;

  String get fechaLabel =>
      fecha.value == null ? 'Seleccionar fecha' : DateFormat('dd/MM/yyyy').format(fecha.value!);

  @override
  void onInit() {
    super.onInit();
    _loadClinics();
  }

  Future<void> _loadClinics() async {
    cargando.value = true;
    try {
      clinicas.assignAll(await _service.getClinics());
    } finally {
      cargando.value = false;
    }
  }

  Future<void> onClinicaChanged(Clinic? c) async {
    clinicaSel.value = c;
    especialidadSel.value = null;
    doctorSel.value = null;
    especialidades.clear();
    doctores.clear();
    slots.clear();
    slotSel.value = null;
    if (c != null) {
      especialidades.assignAll(await _service.getSpecialties(c.id));
    }
  }

  Future<void> onEspecialidadChanged(Specialty? s) async {
    especialidadSel.value = s;
    doctorSel.value = null;
    doctores.clear();
    slots.clear();
    slotSel.value = null;
    if (s != null && clinicaSel.value != null) {
      doctores.assignAll(await _service.getDoctors(clinicaSel.value!.id, s.id));
    }
  }

  Future<void> onDoctorChanged(Doctor? d) async {
    doctorSel.value = d;
    slots.clear();
    slotSel.value = null;
    await _loadAvailability();
  }

  Future<void> seleccionarFecha(BuildContext context) async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: fecha.value ?? hoy,
      firstDate: hoy,
      lastDate: DateTime(hoy.year + 1),
    );
    if (picked != null) {
      fecha.value = picked;
      await _loadAvailability();
    }
  }

  Future<void> _loadAvailability() async {
    if (doctorSel.value == null || fecha.value == null) return;
    final iso = DateFormat('yyyy-MM-dd').format(fecha.value!);
    cargando.value = true;
    try {
      final av = await _service.getAvailability(doctorSel.value!.id, iso);
      slots.assignAll(av.slots);
      slotSel.value = null;
    } finally {
      cargando.value = false;
    }
  }

  Future<void> confirmarCita() async {
    if (doctorSel.value == null || fecha.value == null || slotSel.value == null) {
      Get.snackbar('Faltan datos', 'Selecciona clínica, especialidad, médico, fecha y horario');
      return;
    }
    try {
      final iso = DateFormat('yyyy-MM-dd').format(fecha.value!);
      await _service.createAppointment(
        doctorId: doctorSel.value!.id,
        fechaISO: iso,
        horaInicio: slotSel.value!.horaInicio,
        horaFin: slotSel.value!.horaFin,
      );
      Get.offNamed('/citas');
      Get.snackbar('Cita registrada', '${doctorSel.value!.nombre}\n$fechaLabel ${slotSel.value!.horaInicio.substring(0,5)}');
    } catch (e) {
      Get.snackbar('No disponible', e.toString());
      await _loadAvailability(); // refresca y vuelve a bloquear UI
    }
  }
}
