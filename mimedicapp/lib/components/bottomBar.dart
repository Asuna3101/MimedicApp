import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/navigation/tabs.dart';

class Bottombar extends StatelessWidget {
  final AppTab current;
  final ValueChanged<AppTab> onTap;

  const Bottombar({super.key, required this.onTap, required this.current});

  @override
  Widget build(BuildContext context) {
    final tabs = bottomTabs;
    final selected = tabs.indexOf(current);
    final effectiveIndex = selected == -1 ? 0 : selected;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(top: 6),
        child: BottomNavigationBar(
          currentIndex: effectiveIndex,
          onTap: (i) => onTap(tabs[i]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: Colors.white70,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 40,
          items: tabs.map((t) {
            return BottomNavigationBarItem(
              icon: Icon(bottomTabIcons[t]),
              label: '',
            );
          }).toList(),
        ),
      ),
    );
  }
}
