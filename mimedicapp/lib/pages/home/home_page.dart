import 'package:flutter/material.dart';
import 'package:mimedicapp/components/bottomBar.dart';
import 'package:mimedicapp/components/topBar.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
   int bottomIndex = 0;

  final List<Widget> views = const [
    Center(child: Text("Vista Home", style: TextStyle(fontSize: 22))),
    Center(child: Text("Vista Tareas", style: TextStyle(fontSize: 22))),
    Center(child: Text("Vista Configuración", style: TextStyle(fontSize: 22))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      body: IndexedStack(
        index: bottomIndex,
        children: views,
      
      ),
      bottomNavigationBar: Bottombar(
        currentIndex: bottomIndex,
        onTap: (i) {
          setState(() => bottomIndex = i);
        },
      ),
    );
  }
}