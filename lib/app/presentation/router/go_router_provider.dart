import 'package:ctrl/app/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routePath,

    routes: appRoutes,

    redirect: (_, state) {
      return null;
    },
  );

  return router;
});
