import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'registro_cita_controlador.dart';

class RegistroCitaPantalla extends GetView<RegistroCitaControlador> {
  const RegistroCitaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegistroCitaControlador(), permanent: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.irAAgendar,
                child: const Text('Agendar cita'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: ListTile(
                title: const Text('Agregar'),
                trailing: const Icon(Icons.add, color: AppColors.primary),
                onTap: controller.irAAgendar,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'No tienes citas registradas.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.menu), label: ''),
        ],
      ),
    );
  }
}
