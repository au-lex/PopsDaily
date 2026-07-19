import 'package:flutter/material.dart';
import 'package:news_app/theme/app_color_extension.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPri,
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 15,
                    color: colors.textSec,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.textSec,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}