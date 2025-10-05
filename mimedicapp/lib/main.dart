import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Asegúrate de importar GetX
import 'package:mimedicapp/pages/home/citas/citas_page.dart';
import 'package:mimedicapp/pages/container/container_page.dart';
import 'package:mimedicapp/pages/inicio/inicio_pantalla.dart';
import 'package:mimedicapp/pages/home/medicacion/medicacion_page.dart';
import 'package:mimedicapp/pages/registro/registro_pantalla.dart';
import 'package:mimedicapp/pages/login/login_pantalla.dart';
import 'package:mimedicapp/configs/app_theme.dart'; // Importa tu archivo de temas

void main() {
  runApp(const MimedicApp());
}

class MimedicApp extends StatelessWidget {
  const MimedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Usar GetMaterialApp en lugar de MaterialApp
      title: 'MimedicApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(), // Usa el tema claro desde AppTheme
      themeMode: ThemeMode.light, // Usar tema claro por defecto
      initialRoute: '/app',
      getPages: [
        // Usa getPages en lugar de routes
        GetPage(name: '/inicio', page: () => PaginaInicio()),
        GetPage(name: '/sign-up', page: () => const PaginaRegistro()),
        GetPage(name: '/sign-in', page: () => const PaginaLogin()),
        // GetPage(name: '/home', page: () => PaginaHome()),
        // GetPage(name: '/perfil', page: () => PaginaPerfil()),
        // Aquí puedes agregar más páginas conforme las vayas creando
      ],
    );
  }
}