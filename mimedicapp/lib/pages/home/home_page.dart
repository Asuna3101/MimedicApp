import 'package:flutter/material.dart';
import 'package:mimedicapp/pages/home/components/homeCard.dart';

class PaginaHome extends StatelessWidget {
  const PaginaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aquí vamos a poner botones tipo "cards"
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.9,
                children: [
                  HomeCard(
                    title: "Medicación",
                    imagePath: 'assets/img/homeIcons/medicamentos.png',
                    onTap: () {

                    },
                  ),
                  HomeCard(
                    title: "Citas",
                    imagePath: 'assets/img/homeIcons/citas.png',
                    onTap: () {
                      
                    },
                  ),
                  HomeCard(
                    title: "Comidas",
                    imagePath: 'assets/img/homeIcons/comidas.png',
                    onTap: () {
                      
                    },
                  ),
                  HomeCard(
                    title: "Ejercicio",
                    imagePath: 'assets/img/homeIcons/ejercicios.png',
                    onTap: () {
                      
                    },
                  ),
                  HomeCard(
                    title: "Reportes y seguimiento",
                    imagePath: 'assets/img/homeIcons/reportes.png',
                    onTap: () {
                      
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
