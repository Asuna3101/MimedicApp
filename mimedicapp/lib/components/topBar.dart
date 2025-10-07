import 'package:flutter/material.dart';
import 'package:mimedicapp/configs/colors.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;
  
  const Topbar({super.key, this.onNotifications, this.onProfile});

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
          icon: const Icon(Icons.notifications_none, color: AppColors.accent, size: 30),
          onPressed: onNotifications,
        ),
        IconButton(
          icon: const Icon(Icons.person_2_rounded, color: AppColors.accent, size: 30),
          onPressed: onProfile,
        ),
      ],
    );
  }
}


