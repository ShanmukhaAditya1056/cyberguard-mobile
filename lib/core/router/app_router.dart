import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/breach_result.dart';
import '../../data/models/malware_result.dart';
import '../../data/models/scan_result.dart';
import '../../features/alerts/view/alerts_screen.dart';
import '../../features/breach/view/breach_detail_screen.dart';
import '../../features/breach/view/breach_screen.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/malware/view/app_detail_screen.dart';
import '../../features/malware/view/malware_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/phishing/view/phishing_result_screen.dart';
import '../../features/phishing/view/phishing_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/wifi/view/wifi_screen.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          final index = _indexFromLocation(state.uri.toString());
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavBar(
              currentIndex: index,
              onTap: (selected) => _onNavTap(context, selected),
            ),
          );
        },
        routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/phishing', builder: (context, state) => const PhishingScreen()),
          GoRoute(path: '/malware', builder: (context, state) => const MalwareScreen()),
          GoRoute(path: '/breach', builder: (context, state) => const BreachScreen()),
          GoRoute(path: '/wifi', builder: (context, state) => const WifiScreen()),
          GoRoute(path: '/alerts', builder: (context, state) => const AlertsScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: '/phishing/result',
        builder: (context, state) => PhishingResultScreen(result: state.extra as ScanResult),
      ),
      GoRoute(
        path: '/malware/detail',
        builder: (context, state) => AppDetailScreen(app: state.extra as MalwareApp),
      ),
      GoRoute(
        path: '/breach/detail',
        builder: (context, state) => BreachDetailScreen(result: state.extra as BreachResult),
      ),
    ],
  );

  static int _indexFromLocation(String location) {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/phishing') || location.startsWith('/breach') || location.startsWith('/wifi')) {
      return 1;
    }
    if (location.startsWith('/malware')) return 2;
    if (location.startsWith('/alerts')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  static void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        return;
      case 1:
        context.go('/phishing');
        return;
      case 2:
        context.go('/malware');
        return;
      case 3:
        context.go('/alerts');
        return;
      case 4:
        context.go('/settings');
        return;
    }
  }
}
