import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mimedicapp/pages/container/container_page.dart';
import 'package:mimedicapp/pages/inicio/inicio_pantalla.dart';
import 'package:mimedicapp/pages/registro/registro_pantalla.dart';
import 'package:mimedicapp/pages/login/login_pantalla.dart';
import 'package:mimedicapp/configs/app_theme.dart';
import 'package:mimedicapp/pages/home/citas/listado_cita_medica/citas_list_page.dart';
import 'package:mimedicapp/pages/home/citas/formulario_cita_medica/cita_form_page.dart';

/// imports de siempre...
import 'package:mimedicapp/pages/container/container_controller.dart';

// servicios
import 'package:mimedicapp/services/api_service.dart';
import 'package:mimedicapp/services/health_service.dart';

// controllers de citas
import 'package:mimedicapp/pages/home/citas/listado_cita_medica/citas_list_controller.dart';
import 'package:mimedicapp/pages/home/citas/formulario_cita_medica/cita_form_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

      // 1) Servicios disponibles en toda la app
      initialBinding: BindingsBuilder(() {
        Get.put<ApiService>(ApiService(), permanent: true);
        Get.put<HealthService>(HealthService(), permanent: true);
      }),

      initialRoute: '/inicio',
      getPages: [
        GetPage(name: '/inicio', page: () => PaginaInicio()),
        GetPage(name: '/sign-up', page: () => const PaginaRegistro()),
        GetPage(name: '/sign-in', page: () => const PaginaLogin()),

        // 2) Contenedor con binding: aquí registramos los controllers que usan las tabs
        GetPage(
          name: '/app',
          page: () => const ContainerPage(),
          binding: BindingsBuilder(() {
            Get.put<ContainerController>(ContainerController(), permanent: true);

            // 👇 Estos se crean la primera vez que se usan (lazy) y
            // están disponibles para las vistas del IndexedStack
            Get.lazyPut<CitasListController>(() => CitasListController(Get.find<HealthService>()), fenix: true,);

            Get.lazyPut<CitaFormController>(() => CitaFormController(Get.find<HealthService>()),fenix: true,);
          }),
        ),

        // (Opcional) si navegas a estas rutas por nombre en otros flujos,
        // puedes dejarlas sin binding porque ya están lazy-registrados arriba.
        GetPage(name: '/citas', page: () => const CitasListPage()),
        GetPage(name: '/citas/nuevo', page: () => const CitaFormPage()),
      ],
    );
  }
}