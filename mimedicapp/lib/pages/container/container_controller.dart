import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/navigation/tabs.dart';
import 'package:mimedicapp/pages/configuracion/settings_page.dart';
import 'package:mimedicapp/pages/home/home_navigator.dart';
import 'package:mimedicapp/pages/tareas/tasks_page.dart';

class ContainerController extends GetxController {
  final Rx<AppTab> currentTab = AppTab.home.obs;
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

  bool handleBack() {
    if (tabHistory.isNotEmpty) {
      currentTab.value = tabHistory.removeLast();
      return false; // no salir de la app
    }
    return true; // salir de la app
  }
}