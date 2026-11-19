import 'package:go_router/go_router.dart';
import 'package:msbx/msbx.dart';

import 'package:ctrl/app/shell.dart';
import 'package:ctrl/app/startup.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/settings.dart';

final class AppRoutes() {
  final routes = <RouteBase>[
    // Splash --------------------------------------------------------------------
    GoRoute(
      path: SplashPage.routePath,
      pageBuilder: (_, _) {
        return pageOf(const SplashPage());
      },
    ),

    // ... -----------------------------------------------------------------------
    ...[
      GoRoute(
        path: LevelPage.routePath,
        pageBuilder: (_, state) {
          final params = state.pathParameters;
          final levelId = int.parse(params['id']!);

          return pageOf(LevelPage(id: levelId));
        },
      ),

      GoRoute(
        path: LevelsPage.routePath,
        pageBuilder: (_, _) {
          return pageOf(const LevelsPage());
        },
      ),
    ],

    // Settings ------------------------------------------------------------------
    GoRoute(
      path: SettingsPage.routePath,
      pageBuilder: (_, _) {
        return pageOf(const SettingsPage());
      },
    ),

    // App Shell -----------------------------------------------------------------
    GoRoute(
      path: '/',
      pageBuilder: (_, _) {
        return pageOf(const MainPage());
      },
    ),
  ];
}
