import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/components/bottomBar.dart';
import 'package:mimedicapp/components/topBar.dart';
import 'package:mimedicapp/navigation/tabs.dart';
import 'package:mimedicapp/pages/container/container_controller.dart';
import 'package:mimedicapp/pages/notificaciones/notificaciones_page.dart';
import 'package:mimedicapp/pages/profile/profile_page.dart';

class ContainerPage extends GetView<ContainerController> {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final exit = controller.handleBack();
        if (exit) Get.back();
      },
      child: Scaffold(
        appBar: Topbar(
          onNotifications: () => Get.to(() => const NotificationsPage()),
          onProfile: () => Get.to(() => const ProfilePage()),
        ),
        body: Obx(() {
          final idx = allTabs.indexOf(controller.currentTab.value);
          return IndexedStack(index: idx, children: controller.views);
        }),
        bottomNavigationBar: Obx(() => Bottombar(
              current: controller.currentTab.value,
              onTap: controller.changeTab,
            )),
      ),
    );
  }
}
