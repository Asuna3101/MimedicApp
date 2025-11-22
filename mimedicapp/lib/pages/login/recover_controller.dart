import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/services/user_service.dart';

class RecoverController extends GetxController {
  final _userService = UserService();

  final emailCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final isSending = false.obs;
  final isConfirming = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    codeCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }

  Future<void> sendCode() async {
    if (emailCtrl.text.isEmpty) {
      Get.snackbar('Correo requerido', 'Ingresa tu correo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      return;
    }
    try {
      isSending.value = true;
      await _userService.requestRecover(emailCtrl.text.trim());
      Get.snackbar('Código enviado',
          'Revisa tu correo e ingresa el código de 4 dígitos',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } finally {
      isSending.value = false;
    }
  }

  Future<void> confirm() async {
    if (codeCtrl.text.length != 4) {
      Get.snackbar('Código', 'Ingresa el código de 4 dígitos',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      return;
    }
    if (passCtrl.text.isEmpty || passCtrl.text != confirmCtrl.text) {
      Get.snackbar('Contraseña', 'Las contraseñas no coinciden',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      return;
    }
    try {
      isConfirming.value = true;
      await _userService.confirmRecover(
          email: emailCtrl.text.trim(),
          code: codeCtrl.text.trim(),
          newPassword: passCtrl.text);
      Get.snackbar('Listo', 'Contraseña actualizada',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
      Get.offAllNamed('/sign-in');
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } finally {
      isConfirming.value = false;
    }
  }
}
