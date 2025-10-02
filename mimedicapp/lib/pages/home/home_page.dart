import 'package:flutter/material.dart';
import 'package:mimedicapp/pages/home/bottomBar.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  State<PaginaHome> createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
   int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // aquí tu AppBar y body
      bottomNavigationBar: Bottombar(
        currentIndex: bottomIndex,
        onTap: (i) {
          setState(() => bottomIndex = i);
          print(i);
        },
      ),
    );
  }
}