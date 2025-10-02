import 'package:flutter/material.dart';
import 'package:mimedicapp/components/bottomBar.dart';
import 'package:mimedicapp/configs/colors.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  const Topbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset(
          'assets/img/ico.png',
          height: 10,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.accent, size: 37),
          onPressed: 
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificacionesPage()),
                );
              },
        ),
        IconButton(
          icon: const Icon(Icons.person_2_rounded, color: AppColors.accent, size: 37),
          onPressed:
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilPage()),
                );
          },
        ),
      ],
    );
  }
}



class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Topbar(),
      body: Center(child: Text("Pantalla de notificaciones")),
      bottomNavigationBar: Bottombar(
        currentIndex: bottomIndex,
        onTap: (i) {
          //setState(() => bottomIndex = i);
        },
      ),
    );
  }
}