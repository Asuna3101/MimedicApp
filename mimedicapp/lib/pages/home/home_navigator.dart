import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'home_routes.dart';
import 'package:mimedicapp/pages/home/medicacion/medicacion_page.dart';
import 'package:mimedicapp/pages/home/comidas/comidas_page.dart';
import 'package:mimedicapp/pages/home/ejercicio/ejercicio_page.dart';
import 'package:mimedicapp/pages/home/home_controller.dart';
import 'package:mimedicapp/pages/home/home_page.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
// import 'package:mimedicapp/pages/home/citas/citas_page.dart';
import 'package:mimedicapp/pages/home/comidas/comidas_page.dart';
import 'package:mimedicapp/pages/home/ejercicio/ejercicio_page.dart';
import 'package:mimedicapp/pages/home/medicacion/agregarMedicamento/agregarMedicamento_page.dart';
import 'package:mimedicapp/pages/home/medicacion/editarMedicamento/editarMedicamento.dart';
import 'package:mimedicapp/pages/home/medicacion/medicacion_page.dart';
import 'package:mimedicapp/pages/home/reportes/reportes_page.dart';
import 'package:mimedicapp/pages/home/citas/listado_cita_medica/citas_list_page.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    final routeBuilders = <String, WidgetBuilder>{
      HomeRoutes.inicio: (_) => const HomePage(),
      HomeRoutes.medicacion: (_) => const MedicacionPage(),
      HomeRoutes.citas:      (_) => const CitasListPage(),
      HomeRoutes.comidas:    (_) => const ComidasPage(),
      HomeRoutes.ejercicio:  (_) => const EjercicioPage(),
      HomeRoutes.reportes:   (_) => const ReportesPage(),
      HomeRoutes.agregarMedicamento: (_) => const AgregarMedicamentoPage(),
      HomeRoutes.editarMedicamento: (_) => const EditarMedicamentoPage(),
      // HomeRoutes.citas: (_) => const CitasPage(),
    };

    return Navigator(
      key: Get.nestedKey(1),
      initialRoute: HomeRoutes.inicio,
      onGenerateRoute: (settings) {
        final builder = routeBuilders[settings.name];
        if (builder != null) {
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
      },
    );
    // return Navigator(
    //   key: Get.nestedKey(1),
    //   initialRoute: HomeRoutes.inicio,
    //   onGenerateRoute: (settings) =>
    //       MaterialPageRoute(builder: routes[settings.name] ?? (_) =>
    //       const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
    //           settings: settings),
    // );
  }
}