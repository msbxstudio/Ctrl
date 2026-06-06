import 'package:ctrl/features/level/presentation/views/level_page.dart';
import 'package:go_router/go_router.dart';
import 'package:ctrl/app/index.dart';

final appRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (_, _) {
      return const MainPage();
    },
  ),

  GoRoute(
    path: LevelPage.routePath,
    builder: (_, _) {
      return const LevelPage();
    },
  ),
];
