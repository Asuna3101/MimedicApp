import 'package:flutter/material.dart';

import 'components/med_card.dart';

class MedsList extends StatelessWidget {
  const MedsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meds List Test',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicamentos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: MedicineCard(
              nombre: "Ibuprofeno",
              dosis: "1 pastilla cada 8h con abundante agua y repetir si es necesario",
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Editar medicamento")),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}