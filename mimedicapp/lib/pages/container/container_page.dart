import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/components/bottomBar.dart';
import 'package:mimedicapp/components/topBar.dart';
import 'package:mimedicapp/navigation/tabs.dart';
import 'package:mimedicapp/pages/container/container_controller.dart';
import 'package:mimedicapp/pages/notificaciones/notificaciones_page.dart';
import 'package:mimedicapp/pages/profile/profile_page.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  AppTab current = AppTab.home;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContainerController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final navigator = Get.nestedKey(1)?.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else {
          // Si no hay más en stack, salir de la app
          Get.back();
        }
      },
      child: Scaffold(
        appBar: Topbar(
          onNotifications: () => Get.to(() => const NotificationsPage()),
          onProfile: () => Get.to(() => const ProfilePage()),
        ),
        body: IndexedStack(
          index: allTabs.indexOf(current),
          children: controller.views,
        ),
        bottomNavigationBar: Bottombar(
          current: current,
          onTap: (tab) => setState(() => current = tab),
        ),
      ),
    );
  }
}
