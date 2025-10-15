// lib/pages/container/container_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mimedicapp/navigation/tabs.dart';
import 'package:mimedicapp/pages/home/home_navigator.dart';
import 'package:mimedicapp/pages/tareas/tasks_page.dart';
import 'package:mimedicapp/pages/configuracion/settings_page.dart';

import 'package:mimedicapp/services/health_service.dart';
import 'package:mimedicapp/pages/home/citas/components/upcoming_due_soon_dialog.dart';

class ContainerController extends GetxController {
  // ---------- Tabs ----------
  final currentTab = AppTab.home.obs;
  final List<AppTab> tabHistory = [];

  final List<Widget> views = const [
    HomeNavigator(),
    TasksPage(),
    SettingsPage(),
  ];

  void changeTab(AppTab tab) {
    if (tab != currentTab.value) {
      tabHistory.add(currentTab.value);
      currentTab.value = tab;
    }
  }

  /// Devuélvelo en `WillPopScope`:
  /// `onWillPop: () async => ctrl.handleBack()`
  bool handleBack() {
    if (tabHistory.isNotEmpty) {
      currentTab.value = tabHistory.removeLast();
      return false; // no salir de la app
    }
    return true; // salir de la app
  }

  // ---------- Popup de citas en 30 min ----------
  final _health = Get.find<HealthService>();
  bool _dueSoonDialogShown = false;

  @override
  void onReady() {
    super.onReady();
    _maybeShowDueSoon();
  }

  Future<void> _maybeShowDueSoon() async {
    if (_dueSoonDialogShown) return;
    try {
      final list = await _health.getUpcomingReminders();
      final dueSoon = list.where((e) => e.isDueSoon).toList();
      if (dueSoon.isNotEmpty) {
        _dueSoonDialogShown = true;
        // Mostrar sobre la pantalla actual
        Future.microtask(() {
          Get.dialog(
            UpcomingDueSoonDialog(citas: dueSoon),
            barrierDismissible: true,
          );
        });
      }
    } catch (_) {
      // Silenciamos fallos de red para no bloquear el home
    }
  }
}
