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

  void changeTab(AppTab tab) {
    if (tab != currentTab.value) {
      tabHistory.add(currentTab.value);
      currentTab.value = tab;
    }
  }

  bool handleBack() {
    if (tabHistory.isNotEmpty) {
      currentTab.value = tabHistory.removeLast();
      return false;
    }
    return true;
  }

  // ---------- Alerts lógica ----------
  final _health = Get.find<HealthService>();
  final Set<int> _shownDueSoon = {};
  final Set<int> _shownPast = {};
  Timer? _poller;

  @override
  void onReady() {
    super.onReady();
    _checkAlerts();
    _poller = Timer.periodic(const Duration(minutes: 5), (_) => _checkAlerts());
  }

  @override
  void onClose() {
    _poller?.cancel();
    super.onClose();
  }

  Future<void> _checkAlerts() async {
    try {

      final ups = await _health.getUpcomingReminders();
      final dueSoon = ups.where((e) => e.isDueSoon && !_shownDueSoon.contains(e.id)).toList();
      if (dueSoon.isNotEmpty) {
        _shownDueSoon.addAll(dueSoon.map((e) => e.id));
        await _showAlert(dueSoon, mode: AppointmentAlertMode.dueSoon);
      }

      final hist = await _health.getHistoryReminders();
      final now = DateTime.now();
      final pendingPast = hist.where((e) =>
        e.status == AppointmentStatus.pendiente &&
        e.startsAt.isBefore(now) &&
        !_shownPast.contains(e.id)
      ).toList();

      if (pendingPast.isNotEmpty) {
        _shownPast.addAll(pendingPast.map((e) => e.id));
        await _showAlert(pendingPast, mode: AppointmentAlertMode.past);
      }
    } catch (_) {/* silencioso */}
  }

  Future<void> _showAlert(List<AppointmentReminder> citas, {required AppointmentAlertMode mode}) async {
    await Get.dialog(
      AppointmentAlertDialog(citas: citas, mode: mode, onAction: _handleAction),
      barrierDismissible: true,
    );
  }

  Future<void> _handleAction(AppointmentReminder cita, AppointmentStatus newStatus) async {
    try {
      await _health.updateAppointmentStatus(reminderId: cita.id, status: newStatus);
      if (Get.isRegistered<CitasListController>()) {
        await Get.find<CitasListController>().cargar();
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
      case AppointmentStatus.pendiente:
      default: return 'Marcaste: Pendiente';
    }
  }
}
