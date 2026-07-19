import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/theme/app_color_extension.dart';
import 'package:news_app/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;


  final List<_OnboardData> _slides = const [
    _OnboardData(
      image: 'assets/images/onboarding/news_curation.jpg',
      title: 'News, Without the Noise',
      subtitle:
          'Stay on top of what matters with stories curated from trusted sources around the world.',
    ),
    _OnboardData(
      image: 'assets/images/onboarding/ai_summary.jpg',
      title: 'AI Summaries, In Seconds',
      subtitle:
          'Get the gist of any story instantly — our AI breaks long articles down into quick, clear summaries.',
    ),
    _OnboardData(
      image: 'assets/images/onboarding/voice_reader.jpg',
      title: 'Listen On the Go',
      subtitle:
          'Too busy to read? Let our voice reader narrate the news to you, hands-free.',
    ),
  ];

  bool get _isLastPage => _currentPage == _slides.length - 1;

  void _next() {
    if (_isLastPage) {
      context.go(AppRoutes.login);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() => context.go(AppRoutes.login);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-bleed image PageView
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(slide.image, fit: BoxFit.cover),
                  // Dark overlay so light text stays legible over any photo
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip button
          Positioned(
            top: 6,
            right: 20,
            child: SafeArea(
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

        
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page indicator dots
                  Row(
                    children: List.generate(_slides.length, (index) {
                      final active = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? colors.pri
                              : colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    _slides[_currentPage].title,
                    style: TextStyle(
                      fontFamily: AppTheme.headingFont,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _slides[_currentPage].subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: colors.white.withOpacity(0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Accent pill button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.pri,
                        foregroundColor: colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isLastPage ? 'Get Started' : 'Next',
                        style: TextStyle(
                          color: colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final String image;
  final String title;
  final String subtitle;

  const _OnboardData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}