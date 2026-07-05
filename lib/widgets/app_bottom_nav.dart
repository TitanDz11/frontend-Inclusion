import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom Bottom Navigation Bar with 3 tabs: Home, Reader, Settings.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded, size: 28),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded, size: 28),
          label: 'Reader',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded, size: 28),
          label: 'Settings',
        ),
      ],
      selectedItemColor: AppTheme.accentPrimary,
      unselectedItemColor: AppTheme.textSecondary,
      backgroundColor: AppTheme.surfaceCard,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }
}
