import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mimedicapp/navigation/tabs.dart';
import 'package:mimedicapp/pages/home/home_navigator.dart';
import 'package:mimedicapp/pages/tareas/tasks_page.dart';
import 'package:mimedicapp/pages/configuracion/settings_page.dart';

import 'package:mimedicapp/services/health_service.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';
import 'package:mimedicapp/pages/home/citas/components/alerts/appointment_alert_dialog.dart';
import 'package:mimedicapp/pages/home/citas/citas_controller.dart';

class ContainerController extends GetxController {
  // ---------- Tabs ----------
  final currentTab = AppTab.home.obs;
  final List<AppTab> tabHistory = [];
  final List<Widget> views = const [HomeNavigator(), TasksPage(), SettingsPage()];

  // ALERTS control
  final _health = Get.find<HealthService>();
  final Set<int> _shownDueSoon = {}; // evita repetir las mismas proximas en esta sesión
  Timer? _poller;
  bool _isAlertOpen = false;

  void changeTab(AppTab tab) async {
    if (tab != currentTab.value) {
      tabHistory.add(currentTab.value);
      currentTab.value = tab;

      // 👉 Fuerza chequeo al ir a HOME
      if (tab == AppTab.home) {
        await triggerAlertsCheck();
      }
    }
  }

  bool handleBack() {
    if (tabHistory.isNotEmpty) {
      currentTab.value = tabHistory.removeLast();
      return false;
    }
    return true;
  }

  @override
  void onReady() {
    super.onReady();
    _checkAlerts(); // primer chequeo al abrir
    _poller = Timer.periodic(const Duration(minutes: 5), (_) => _checkAlerts());
  }

  @override
  void onClose() {
    _poller?.cancel();
    super.onClose();
  }

  /// 👉 Llama a esto desde otras pantallas (p.ej. al volver de "Agregar Cita")
  Future<void> triggerAlertsCheck() => _checkAlerts();

  Future<void> _checkAlerts() async {
    if (_isAlertOpen) return; // evita abrir múltiples diálogos a la vez
    try {
      // 1) Próximas (<=30 min), el backend service marca is_due_soon
      final ups = await _health.getUpcomingReminders();
      final dueSoon = ups.where((e) => e.isDueSoon && !_shownDueSoon.contains(e.id)).toList();
      if (dueSoon.isNotEmpty) {
        _shownDueSoon.addAll(dueSoon.map((e) => e.id));
        await _showAlert(dueSoon, mode: AppointmentAlertMode.dueSoon);
      }

      // 2) Pasadas (últimos 30 min) aún PENDIENTES
      final overdue = await _health.getOverdueReminders();
      if (overdue.isNotEmpty) {
        await _showAlert(overdue, mode: AppointmentAlertMode.past);
      }
    } catch (_) {
      // silencioso
    }
  }

  Future<void> _showAlert(List<AppointmentReminder> citas, {required AppointmentAlertMode mode}) async {
    if (_isAlertOpen) return;
    _isAlertOpen = true;
    try {
      await Get.dialog(
        AppointmentAlertDialog(
          citas: citas,
          mode: mode,
          onAction: _handleAction,
        ),
        barrierDismissible: true, // solo se cierra con X o cuando no queden ítems
      );
    } finally {
      _isAlertOpen = false;
    }
  }

  Future<void> _handleAction(AppointmentReminder cita, AppointmentStatus newStatus) async {
    try {
      await _health.updateAppointmentStatus(reminderId: cita.id, status: newStatus);
      if (Get.isRegistered<CitasListController>()) {
        await Get.find<CitasListController>().cargar(); // refresca “Próximas”
      }
      Get.snackbar(
        'Estado actualizado',
        _statusMsg(newStatus),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  String _statusMsg(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.asistido: return 'Marcaste: Asistido';
      case AppointmentStatus.noAsistido: return 'Marcaste: No asistido';
      case AppointmentStatus.pendiente: return 'Marcaste: Pendiente';
    }
  }
}
