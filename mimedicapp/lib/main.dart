import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Asegúrate de importar GetX
import 'package:mimedicapp/pages/container/container_page.dart';
import 'package:mimedicapp/pages/inicio/inicio_pantalla.dart';
import 'package:mimedicapp/pages/registro/registro_pantalla.dart';
import 'package:mimedicapp/pages/login/login_pantalla.dart';
import 'package:mimedicapp/configs/app_theme.dart'; // Importa tu archivo de temas
import 'package:mimedicapp/pages/registro_cita_medica/registro_cita_pantalla.dart';
import 'package:mimedicapp/pages/agendar_cita_medica/agendar_cita_pantalla.dart';
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
      initialRoute: '/inicio',
      getPages: [
        // Usa getPages en lugar de routes
        GetPage(name: '/inicio', page: () => PaginaInicio()),
        GetPage(name: '/sign-up', page: () => const PaginaRegistro()),
        GetPage(name: '/sign-in', page: () => const PaginaLogin()),
        GetPage(name: '/app', page: () => const ContainerPage()),
        // GetPage(name: '/home', page: () => PaginaHome()),
        // GetPage(name: '/perfil', page: () => PaginaPerfil()),
        // Aquí puedes agregar más páginas conforme las vayas creando
        GetPage(name: '/citas', page: () => const RegistroCitaPantalla()),
        GetPage(name: '/citas/agendar', page: () => const AgendarCitaPantalla()),
      ],
    );
  }
}