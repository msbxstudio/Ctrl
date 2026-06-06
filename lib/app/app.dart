import 'package:ctrl/app/index.dart';
import 'package:ctrl/shared/theme/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() {
    return MainAppState();
  }
}

final class MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final router = ref.watch(goRouterProvider);
    final appConfig = ref.watch(appConfigRepositoryProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CTRL',

      theme: theme.dark,
      themeMode: ThemeMode.dark,

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,

      locale: appConfig.locale,
      routerConfig: router,
    );
  }
}
