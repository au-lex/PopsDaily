import 'package:flutter/material.dart';
import 'package:news_app/theme/app_color_extension.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  static const _accentTeal = Color(0xff2E9E8E);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          final isSelected = category == selected;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onSelected(category),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : colors.textSec,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              backgroundColor: Colors.transparent,
              selectedColor: const Color(0xFF2E9E8E),
              showCheckmark: false,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? _accentTeal : colors.textSec.withOpacity(0.3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
          );
        },
      ),
    );
  }
}