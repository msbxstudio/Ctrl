import 'package:ctrl/app/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:go_router/go_router.dart';

final appRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (_, _) {
      return const MainPage();
    },
  ),

  GoRoute(
    path: SplashPage.routePath,
    builder: (_, _) {
      return const SplashPage();
    },
  ),

  GoRoute(
    path: LevelPage.routePath,
    builder: (_, state) {
      return LevelPage(id: int.parse(state.pathParameters['id']!));
    },
  ),

  GoRoute(
    path: LevelsPage.routePath,
    builder: (_, _) {
      return const LevelsPage();
    },
  ),

  GoRoute(
    path: SettingsPage.routePath,
    builder: (_, _) {
      return const SettingsPage();
    },
  ),
];
