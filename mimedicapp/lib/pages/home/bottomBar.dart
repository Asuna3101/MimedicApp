import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';

class Bottombar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Bottombar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.accent,
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(top: 6),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.white,
          unselectedItemColor: Colors.white70,
          enableFeedback: false,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 40,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.edit_note_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: ''),
          ],
        ),
      ),
    );
  }
}
