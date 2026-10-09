import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              );
            }
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.primary,
                size: 24,
              );
            }
            return IconThemeData(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              size: 24,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_rounded),
              selectedIcon: const Icon(Icons.home_rounded)
                  .animate(target: selectedIndex == 0 ? 1 : 0)
                  .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 200.ms),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_rounded),
              selectedIcon: const Icon(Icons.history_rounded)
                  .animate(target: selectedIndex == 1 ? 1 : 0)
                  .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 200.ms),
              label: 'History',
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_rounded),
              selectedIcon: const Icon(Icons.settings_rounded)
                  .animate(target: selectedIndex == 2 ? 1 : 0)
                  .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 200.ms),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
