import 'package:flutter/material.dart';
import 'package:news_app/componets/home/breaking_card.dart';
import 'package:news_app/componets/home/category_chip.dart';
import 'package:news_app/componets/home/home_header.dart';
import 'package:news_app/componets/home/news_card.dart';
import 'package:news_app/componets/home/section.dart';
import 'package:news_app/data/mock_news.dart';
import 'package:news_app/theme/app_color_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  static const _categories = ['All', 'Politics', 'Technology', 'Business'];

  @override
  Widget build(BuildContext context) {
    final filteredStories = _selectedCategory == 'All'
        ? mockRecentStories
        : mockRecentStories
              .where((a) => a.category == _selectedCategory)
              .toList();

    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    SectionTitle(title: "Trending", onSeeAll: () {}),
                    const SizedBox(height: 18),
                    BreakingNews(articles: mockBreakingNews),
                    const SizedBox(height: 30),

                    SectionTitle(title: "Recent Stories", onSeeAll: () {}),
                    const SizedBox(height: 16),
                    CategoryFilter(
                      categories: _categories,
                      selected: _selectedCategory,
                      onSelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredStories.length,
                      itemBuilder: (_, index) {
                        return NewsCard(article: filteredStories[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}