import 'package:flutter/material.dart';
import 'package:mimedicapp/components/bottomBar.dart';
import 'package:mimedicapp/components/topBar.dart';
import 'package:mimedicapp/navigation/tabs.dart';
import 'package:mimedicapp/pages/configuracion/configuracion_page.dart';
import 'package:mimedicapp/pages/home/home_page.dart';
import 'package:mimedicapp/pages/notificaciones/notificaciones_page.dart';
import 'package:mimedicapp/pages/profile/profile_page.dart';
import 'package:mimedicapp/pages/tareas/tareas_page.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  AppTab current = AppTab.home;

  final List<Widget> _views = const [
    PaginaHome(),
    PaginaTareas(),
    PaginaConfiguracion(),
    PaginaNotificaciones(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(
        onNotifications: () => setState(() => current = AppTab.notifications),
        onProfile: () => setState(() => current = AppTab.profile),
      ),

      body: IndexedStack(
        index: allTabs.indexOf(current),
        children: _views,
      ),

      bottomNavigationBar: Bottombar(
        current: current,
        onTap: (tab) => setState(() => current = tab),
      ),
    );
  }
}