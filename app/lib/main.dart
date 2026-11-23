import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ctrl/app/app.dart';
import 'package:ctrl/features/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  final preferences = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      fallbackLocale: const Locale('en'),
      path: 'assets/l10n',

      child: ProviderScope(
        overrides: [
          preferencesRepositoryProvider.overrideWith((_) {
            final datasource = SharedPreferencesDataSourceImpl(preferences);

            return PreferencesRepositoryImpl(shared: datasource);
          }),
        ],
        child: const MainApp(),
      ),
    ),
  );
}
