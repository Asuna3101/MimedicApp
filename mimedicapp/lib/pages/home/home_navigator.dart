import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/pages/home/home_controller.dart';
import 'package:mimedicapp/pages/home/home_page.dart';
import 'package:mimedicapp/pages/home/home_routes.dart';
import 'package:mimedicapp/pages/home/citas/citas_page.dart';
import 'package:mimedicapp/pages/home/comidas/comidas_page.dart';
import 'package:mimedicapp/pages/home/ejercicio/ejercicio_page.dart';
import 'package:mimedicapp/pages/home/medicacion/agregarMedicamento/agregarMedicamento_page.dart';
import 'package:mimedicapp/pages/home/medicacion/editarMedicamento/editarMedicamento_page.dart';
import 'package:mimedicapp/pages/home/medicacion/medicacion_page.dart';
import 'package:mimedicapp/pages/home/reportes/reportes_page.dart';

class HomeNavigator extends StatelessWidget {

  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController()); // mantener vivo mientras viva la tab

    final routeBuilders = <String, WidgetBuilder>{
      HomeRoutes.inicio: (_) => const HomePage(),
      HomeRoutes.medicacion: (_) => const MedicacionPage(),
      HomeRoutes.agregarMedicamento: (_) => const AgregarMedicamentoPage(),
      HomeRoutes.editarMedicamento: (_) => const EditarMedicamentoPage(),
      HomeRoutes.citas: (_) => const CitasPage(),
      HomeRoutes.comidas: (_) => const ComidasPage(),
      HomeRoutes.ejercicio: (_) => const EjercicioPage(),
      HomeRoutes.reportes: (_) => const ReportesPage(),
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
  }
}
