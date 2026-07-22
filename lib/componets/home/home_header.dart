import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/theme/app_color_extension.dart';
import 'package:news_app/theme/theme_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.surface,
                child: Icon(Icons.person, color: colors.textSec),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning 👋", style: TextStyle(color: colors.textSec, fontSize: 13)),
                    Text(
                      "Script Dev",
                      style: TextStyle(color: colors.textPri, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(26)),
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeController,
                  builder: (context, mode, _) {
                    return IconButton(
                      onPressed: () => themeController.toggle(),
                      icon: Icon(
                        mode == ThemeMode.dark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                        color: colors.textPri,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(26)),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none_rounded, color: colors.textPri),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Tap-through search bar — no typing here, just routes to SearchScreen
          GestureDetector(
            onTap: () => context.push(AppRoutes.search),
            child: Container(
              height: 56,
              decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(58)),
              child: TextField(
                enabled: false,
                style: TextStyle(color: colors.textPri),
                decoration: InputDecoration(
                  hintText: "Search news...",
                  hintStyle: TextStyle(color: colors.textSec),
                  prefixIcon: Icon(Icons.search, color: colors.textSec),
                  suffixIcon: Icon(Icons.mic_none_rounded, color: colors.textSec),
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}