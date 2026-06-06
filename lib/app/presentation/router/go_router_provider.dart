import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',

    routes: appRoutes,

    redirect: (_, state) {
      return null;
    },
  );

  return router;
});
