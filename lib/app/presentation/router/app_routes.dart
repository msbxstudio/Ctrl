import 'package:go_router/go_router.dart';
import 'package:ctrl/app/index.dart';

final appRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (_, _) {
      return const MainPage();
    },
  ),
];
