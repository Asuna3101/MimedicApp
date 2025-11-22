import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'profile_controller.dart';
import 'profile_actions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Titulo',
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.accent, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: const Icon(Icons.person,
                    size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                c.nombre.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _ProfileField(
                  icon: Icons.email, label: 'Correo', value: c.correo.value),
              _ProfileField(
                  icon: Icons.phone, label: 'Teléfono', value: c.celular.value),
              _ProfileField(
                icon: Icons.cake,
                label: 'Fecha de nacimiento',
                value: c.fechaNacimiento.value != null
                    ? _formatDate(c.fechaNacimiento.value!)
                    : '-',
              ),
              const SizedBox(height: 16),
              ProfileActions(
                onChangePhoto: () => _showPhotoDialog(context, c),
                onChangePassword: () => _showChangePassDialog(context, c),
                onDeleteAccount: () => _confirmDelete(context, c),
                onRecoverAccount: () => _showRecoverDialog(context, c),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileField(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime d) {
  return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

void _showNotImpl(String msg) {
  Get.snackbar('Acción', '$msg pendiente de completar',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2));
}

void _showPhotoDialog(BuildContext context, ProfileController c) {
  Get.dialog(AlertDialog(
    title: const Text('Cambiar foto'),
    content: const Text('Selecciona una foto desde tu galería.'),
    actions: [
      TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
      ElevatedButton(
        onPressed: () async {
          await c.pickAndUploadPhoto();
          Get.back();
        },
        child: const Text('Abrir galería'),
      ),
    ],
  ));
}

void _showChangePassDialog(BuildContext context, ProfileController c) {
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Cambiar contraseña'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldCtrl,
            decoration: const InputDecoration(labelText: 'Contraseña actual'),
            obscureText: true,
          ),
          TextField(
            controller: newCtrl,
            decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            obscureText: true,
          ),
          TextField(
            controller: confirmCtrl,
            decoration: const InputDecoration(labelText: 'Confirmar nueva'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (newCtrl.text == confirmCtrl.text &&
                newCtrl.text.isNotEmpty &&
                oldCtrl.text.isNotEmpty) {
              await c.changePassword(oldPass: oldCtrl.text, newPass: newCtrl.text);
              Get.back();
            } else {
              Get.snackbar('Error', 'Las contraseñas no coinciden',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2));
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

void _confirmDelete(BuildContext context, ProfileController c) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Eliminar cuenta'),
      content: const Text(
          'Esta acción desactivará tu cuenta. ¿Deseas continuar?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () async {
            await c.deleteAccount();
            Get.back();
          },
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
}

void _showRecoverDialog(BuildContext context, ProfileController c) {
  final emailCtrl = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Recuperar cuenta'),
      content: TextField(
        controller: emailCtrl,
        decoration: const InputDecoration(labelText: 'Correo'),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (emailCtrl.text.isNotEmpty) {
              await c.recoverAccount(emailCtrl.text.trim());
              Get.back();
            }
          },
          child: const Text('Enviar'),
        ),
      ],
    ),
  );
}
