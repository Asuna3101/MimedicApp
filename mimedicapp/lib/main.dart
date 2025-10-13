import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mimedicapp/pages/container/container_page.dart';
import 'package:mimedicapp/pages/inicio/inicio_pantalla.dart';
import 'package:mimedicapp/pages/registro/registro_pantalla.dart';
import 'package:mimedicapp/pages/login/login_pantalla.dart';
import 'package:mimedicapp/configs/app_theme.dart';
import 'package:mimedicapp/pages/home/citas/listado_cita_medica/citas_list_page.dart';
import 'package:mimedicapp/pages/home/citas/formulario_cita_medica/cita_form_page.dart';

void main() {
  runApp(const MimedicApp());
}

class MimedicApp extends StatelessWidget {
  const MimedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MimedicApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      themeMode: ThemeMode.light,
      initialRoute: '/inicio',
      getPages: [
        GetPage(name: '/inicio', page: () => PaginaInicio()),
        GetPage(name: '/sign-up', page: () => const PaginaRegistro()),
        GetPage(name: '/sign-in', page: () => const PaginaLogin()),
        GetPage(name: '/app', page: () => const ContainerPage()),
        GetPage(name: '/citas', page: () => const CitasListPage()), 
        GetPage(name: '/citas/nuevo', page: () => const CitaFormPage()),
      ],
    );
  }
}
