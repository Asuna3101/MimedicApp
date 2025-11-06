import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/components/custom_button.dart';
import 'package:mimedicapp/pages/configuracion/settings_controller.dart';
import 'package:mimedicapp/configs/colors.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _confirmLogout(BuildContext context, SettingsController controller) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Cerrar sesión')),
        ],
      ),
    );

    if (confirm == true) {
      await controller.performLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text(
                  'Configuración',
                  style: TextStyle(
                    fontFamily: 'Blond',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

          // Logout button (visual only, controller handles logic)
          Obx(() {
            if (controller.isProcessing.value) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                      SizedBox(width: 12),
                      Text('Cerrando sesión...'),
                    ],
                  ),
                ),
              );
            }

            return CustomButton(
              title: 'Cerrar sesión',
              onPressed: () => _confirmLogout(context, controller),
            );
          }),
        ],
      ),
    );
  }
}
