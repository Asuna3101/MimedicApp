// // lib/pages/home/citas/listado_cita_medica/citas_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:mimedicapp/configs/colors.dart';
// import 'citas_list_controller.dart';

// class CitasListPage extends GetView<CitasListController> {
//   const CitasListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.cargando.value) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final citas = controller.citas;
//           final fmt = DateFormat('dd/MM/yyyy – HH:mm');

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 12),
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Image.asset(
//                         'assets/img/homeIcons/citas.png',
//                         height: 70,
//                         errorBuilder: (_, __, ___) => const Icon(
//                           Icons.calendar_month,
//                           size: 56,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       'Citas',
//                       style: TextStyle(
//                         fontFamily: 'Titulo',
//                         fontSize: 30,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),

//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: () async {
//                       final created = await Get.toNamed('/citas/nuevo');
//                       if (created == true) controller.cargar();
//                     },
//                     icon: const Icon(Icons.add, color: AppColors.primary, size: 28),
//                     label: const Text(
//                       'Agregar',
//                       style: TextStyle(
//                         fontFamily: 'Titulo',
//                         fontSize: 18,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       side: const BorderSide(color: AppColors.primary, width: 1.5),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 if (citas.isEmpty)
//                   const _Empty()
//                 else ...[
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: citas.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemBuilder: (_, i) {
//                       final r = citas[i];
//                       final f = fmt.format(r.startsAt);
//                       return Card(
//                         child: ListTile(
//                           leading: const Icon(Icons.calendar_month),
//                           title: Text('${r.doctor.nombre}  •  $f'),
//                           subtitle: Text(
//                             'Clínica ${r.clinic.nombre} • Esp. ${r.specialty.nombre}'
//                             '${r.notes == null ? "" : "\n${r.notes}"}',
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class _Empty extends StatelessWidget {
//   const _Empty();

//   @override
//   Widget build(BuildContext context) => Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Icon(Icons.event_busy, size: 56),
//               SizedBox(height: 10),
//               Text('No tienes citas registradas'),
//               SizedBox(height: 4),
//               Text('Pulsa “Agregar” para registrar tu próxima cita.'),
//             ],
//           ),
//         ),
//       );
// }
