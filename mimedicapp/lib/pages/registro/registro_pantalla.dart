import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/components/custom_button.dart';

class PaginaRegistro extends StatelessWidget {
  const PaginaRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(
            fontFamily: 'Blond',
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/img/ico.png',
                height: 100,
              ),
              const SizedBox(height: 30),

              // Título
              const Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontFamily: 'Blond',
                  fontSize: 28,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),

              // Campos de texto (ejemplo)
              TextField(
                style: const TextStyle(fontFamily: 'Formularios'),
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                style: const TextStyle(fontFamily: 'Formularios'),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                style: const TextStyle(fontFamily: 'Formularios'),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botón de registro
              ElevatedButton(
                onPressed: () {
                  // Aquí implementarás la lógica de registro
                  Get.snackbar('Registro', 'Funcionalidad en desarrollo');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    fontFamily: 'Botones',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Enlace para ir al login
              TextButton(
                onPressed: () {
                  Get.offNamed('/sign-in'); // Regresar al inicio
                },
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
