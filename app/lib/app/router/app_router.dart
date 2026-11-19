import 'package:go_router/go_router.dart';
import 'package:ctrl/app/startup.dart';

import 'app_routes.dart';

final class AppRouter() {
  final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routePath,

    routes: AppRoutes().routes,

    redirect: (_, state) {
      return null;
    },
  );
}
