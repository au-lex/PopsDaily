import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:news_app/theme/app_colors.dart'; // adjust path if needed

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Iconsax.home_2, Iconsax.home_25, "Home"),
    (Iconsax.discover_1, Iconsax.discover_1, "Explore"),
    (Iconsax.archive_1, Iconsax.archive_1, "Bookmark"),
    (Iconsax.frame_1, Iconsax.frame_1, "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
        child: Container(
          height: 68,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColors.textSec.withOpacity(0.3), width: 0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (index) {
              final selected = currentIndex == index;
              final (icon, activeIcon, label) = _items[index];

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  width: selected ? 120 : 46,
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.pri : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          selected ? activeIcon : icon,
                          size: 18,
                          color: selected ? AppColors.white : AppColors.textSec,
                        ),
                      ),
                      if (selected)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                color: AppColors.textPri,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}