import 'package:flutter/material.dart';
import 'package:mimedicapp/pages/home/bottomBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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