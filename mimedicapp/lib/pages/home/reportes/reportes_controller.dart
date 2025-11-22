import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:mimedicapp/models/report_event.dart';
import 'package:mimedicapp/models/report_summary.dart';
import 'package:mimedicapp/services/reportes_service.dart';
import 'package:mimedicapp/services/user_service.dart';
import 'package:mimedicapp/utils/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportesController extends GetxController {
  final _userService = UserService();
  final _reportes = ReportesService();

  final isLoading = false.obs;
  final error = RxnString();
  final nombre = ''.obs;
  final fechaNacimiento = Rxn<DateTime>();
  final eventos = <ReportEventModel>[].obs;
  final modulos = <ReportEventType, List<ReportEventModel>>{}.obs;
  final descargando = false.obs;

  StreamSubscription<dynamic>? _eventSub;
  static const _tomasHistoryKey = 'completed_tomas_history';

  @override
  void onInit() {
    super.onInit();
    _listenMedicationEvents();
    cargar();
  }

  @override
  void onClose() {
    _eventSub?.cancel();
    super.onClose();
  }

  Future<void> cargar() async {
    isLoading.value = true;
    error.value = null;
    try {
      final summary = await _reportes.getSummary();
      final user = summary.user;
      nombre.value = user.nombre;
      fechaNacimiento.value = user.fechaNacimiento;

      final List<ReportEventModel> data = [...summary.timeline];

      // merge local tomas (offline)
      final tomasLocal = await _readMedicationEvents();
      data.addAll(tomasLocal.map(
        (e) => ReportEventModel(
          type: ReportEventType.toma,
          title: e['title'] ?? 'Toma completada',
          subtitle: e['detail'] ?? e['subtitle'] ?? '',
          status: e['status'] ?? 'Completado',
          date: DateTime.tryParse(
                  e['completedAt'] ?? e['timestamp'] ?? '') ??
              DateTime.now(),
        ),
      ));

      data.sort((a, b) => b.date.compareTo(a.date));
      eventos.assignAll(data);
      modulos.assignAll(_groupByType(data));
    } catch (e) {
      error.value = 'No se pudo cargar los reportes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> descargarModulo(ReportEventType type) async {
    try {
      descargando.value = true;
      final mod = reportEventTypeToString(type);
      final res = await _reportes.downloadModule(mod);
      return res;
    } catch (e) {
      error.value = 'No se pudo descargar: $e';
      return null;
    } finally {
      descargando.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _readMedicationEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_tomasHistoryKey) ?? <String>[];
    return raw.map((e) {
      final map = Map<String, dynamic>.from(jsonDecode(e));
      if (map['completedAt'] == null && map['timestamp'] != null) {
        map['completedAt'] = map['timestamp'];
      }
      return map;
    }).toList();
  }

  void _listenMedicationEvents() {
    _eventSub = EventBus().stream.listen((e) async {
      if (e['type'] == 'toma_event' && e['action'] == 'tomado') {
        final timestamp = e['timestamp'] as String? ??
            DateTime.now().toUtc().toIso8601String();
        await _persistMedicationEvent({
          'id': 'med_${e['tomaId'] ?? timestamp}',
          'category': 'TaskCategory.medicamentos',
          'title': 'Toma completada',
          'detail':
              '${e['medicamentoNombre'] ?? ''} ${e['dosis'] ?? ''} ${e['unidad'] ?? ''}'.trim(),
          'completedAt': timestamp,
          'status': 'Completado',
        });
      }
    });
  }

  Future<void> _persistMedicationEvent(Map<String, dynamic> event) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_tomasHistoryKey) ?? <String>[];
    raw.add(jsonEncode(event));
    await prefs.setStringList(_tomasHistoryKey, raw);
    await cargar();
  }

  Map<ReportEventType, List<ReportEventModel>> _groupByType(
      List<ReportEventModel> list) {
    final Map<ReportEventType, List<ReportEventModel>> res = {};
    for (final e in list) {
      res.putIfAbsent(e.type, () => []);
      res[e.type]!.add(e);
    }
    for (final v in res.values) {
      v.sort((a, b) => b.date.compareTo(a.date));
    }
    return res;
  }
}
