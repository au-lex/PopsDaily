import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/bottom_tab.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/screens/auth_screen/forgotpsw_screen.dart';
import 'package:news_app/screens/auth_screen/login_screen.dart';
import 'package:news_app/screens/auth_screen/resetpsw_screen.dart';
import 'package:news_app/screens/auth_screen/signup_screen.dart';

import 'package:news_app/screens/bookmark_screen/bookmart_screen.dart';
import 'package:news_app/screens/explore/explore_screen.dart';
import 'package:news_app/screens/home_screen/home_screen.dart';
import 'package:news_app/screens/news_category_screen/category_screen.dart';
import 'package:news_app/screens/news_details/full_news.dart';
import 'package:news_app/screens/news_details/news_details.dart';
import 'package:news_app/screens/news_details/trending_news.dart';
import 'package:news_app/screens/notification/notification_screen.dart';

import 'package:news_app/screens/onboarding/onboarding_screen.dart';
import 'package:news_app/screens/profile/edit_profile.dart';
import 'package:news_app/screens/profile/profile_screen.dart';
import 'package:news_app/screens/profile/security_screen.dart';
import 'package:news_app/screens/search_screen/search_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookmark = '/bookmark';
  static const String profile = '/profile';
  static const String article = '/article';
  static const String editPersonalInfo = '/editPersonalInfo';
  static const String security = '/security';
  static const String forgotpassword = '/forgotpassword';
  static const String resetpassword = '/resetpassword';
  static const publisher = '/publisher';
  static const notifications = '/notifications';

  static const String seeAll = '/see_all';
  static const String trending = '/trending';

  static const search = '/search';

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
        path: signup,
        name: signup,
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: seeAll,
        name: seeAll,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SeeAllScreen(
            title: extra?['title'] as String? ?? 'See All',
            initialCategory: extra?['initialCategory'] as String? ?? '',
          );
        },
      ),

      GoRoute(
        path: notifications,
        name: notifications,
        builder: (context, state) {
          return NotificationsScreen();
        },
      ),

      GoRoute(
        path: trending,
        name: trending,
        builder: (context, state) {
          return TrendingScreen();
        },
      ),

      GoRoute(
        path: forgotpassword,
        name: forgotpassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: resetpassword,
        name: resetpassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ResetPasswordScreen(email: extra?['email'] as String?);
        },
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
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),

      GoRoute(
        path: AppRoutes.publisher,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PublisherArticlesScreen(
            sourceId: extra?['sourceId'] as int? ?? 0,
            displayName: extra?['displayName'] as String?,
          );
        },
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
