import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/bottom_tab.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/screens/auth_screen/login_screen.dart';
import 'package:news_app/screens/bookmark_screen/bookmart_screen.dart';
import 'package:news_app/screens/explore/explore_screen.dart';
import 'package:news_app/screens/home_screen/home_screen.dart';
import 'package:news_app/screens/news_details/news_details.dart';

import 'package:news_app/screens/onboarding/onboarding_screen.dart';
import 'package:news_app/screens/profile/edit_profile.dart';
import 'package:news_app/screens/profile/profile_screen.dart';
import 'package:news_app/screens/profile/security_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookmark = '/bookmark';
  static const String profile = '/profile';
  static const String article = '/article';
  static const String editPersonalInfo = '/editPersonalInfo';
  static const String security = '/security';

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: editPersonalInfo,
        name: editPersonalInfo,
        builder: (context, state) => const EditPersonalInfoScreen(),
      ),

      GoRoute(
        path: security,
        name: security,
        builder: (context, state) => const SecurityScreen(),
      ),

      GoRoute(
        path: article,
        name: 'article',
        builder: (context, state) {
          final article = state.extra as NewsArticle;
          return ArticleScreen(article: article);
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: explore,
                name: 'explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: bookmark,
                name: 'bookmark',
                builder: (context, state) => const BookmarkScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
}
