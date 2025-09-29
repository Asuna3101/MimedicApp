import 'package:flutter/material.dart';
import 'configs/colors.dart';

void main() {
  runApp(const MimedicTestApp());
}

class MimedicTestApp extends StatelessWidget {
  const MimedicTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mimetic Test - Fonts & Colors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.white,
      ),
      home: const FontAndColorTestScreen(),
    );
  }
}

class FontAndColorTestScreen extends StatelessWidget {
  const FontAndColorTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Mimetic - Prueba de Diseño',
          style: TextStyle(
            fontFamily: 'Blond',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Colores
            _buildSectionTitle('🎨 Paleta de Colores'),
            const SizedBox(height: 16),
            _buildColorPalette(),

            const SizedBox(height: 30),

            // Sección de Fuentes
            _buildSectionTitle('📝 Fuentes Personalizadas'),
            const SizedBox(height: 16),
            _buildFontShowcase(),

            const SizedBox(height: 30),

            // Sección de Componentes de Prueba
            _buildSectionTitle('🧪 Componentes de Prueba'),
            const SizedBox(height: 16),
            _buildComponentsShowcase(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Blond',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildColorPalette() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColorItem(
                'Primary (Morado)', AppColors.primary, Colors.white),
            _buildColorItem(
                'White (Blanco)', AppColors.white, AppColors.primary),
            _buildColorItem('Accent (Rosado)', AppColors.accent, Colors.white),
            _buildColorItem('Grey 200', AppColors.grey200, AppColors.primary),
            _buildColorItem('Grey 400', AppColors.grey400, Colors.white),
            _buildColorItem('Error (Rojo)', AppColors.error, Colors.white),
            _buildColorItem('Success (Verde)', AppColors.success, Colors.white),
            _buildColorItem(
                'Warning (Amarillo)', AppColors.warning, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildColorItem(String name, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey400, width: 1),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            color.toString(),
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 12,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontShowcase() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFontExample(
                'Blond', 'Fuente Blond - Para títulos principales'),
            _buildFontExample(
                'Regular', 'Fuente Regular - Para texto general y contenido'),
            _buildFontExample(
                'Formularios', 'Fuente Formularios - Para campos de entrada'),
            _buildFontExample(
                'Botones', 'Fuente Botones - Para etiquetas de botones'),
          ],
        ),
      ),
    );
  }

  Widget _buildFontExample(String fontFamily, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fontFamily.toUpperCase(),
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Abcdefghijklmnopqrstuvwxyz 1234567890',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 14,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsShowcase() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón Principal
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Botón Principal',
                style: TextStyle(
                  fontFamily: 'Botones',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Campo de Texto
            TextField(
              style: const TextStyle(
                fontFamily: 'Formularios',
                fontSize: 16,
                color: AppColors.primary,
              ),
              decoration: InputDecoration(
                labelText: 'Campo de Prueba',
                labelStyle: const TextStyle(
                  fontFamily: 'Formularios',
                  color: AppColors.grey400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.grey400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botones de Estado
            Row(
              children: [
                Expanded(
                  child: _buildStatusButton('Éxito', AppColors.success),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton('Error', AppColors.error),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton('Alerta', AppColors.warning),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Botones',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
