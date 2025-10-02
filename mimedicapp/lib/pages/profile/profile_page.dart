import 'package:flutter/material.dart';
import 'package:mimedicapp/components/topBar.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Topbar(),
      body: Center(child: Text("Pantalla de perfil")),
    );
  }
}