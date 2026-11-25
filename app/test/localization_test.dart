import 'dart:convert';
import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msbx/exceptions.dart';

import 'package:ctrl/core/utils.dart';
import 'package:ctrl/features/settings.dart';

Map<String, dynamic> readCatalog(String language) {
  return jsonDecode(File('assets/l10n/$language.json').readAsStringSync())
      as Map<String, dynamic>;
}

Map<String, String> flatten(Map<String, dynamic> data, [String prefix = '']) {
  return {
    for (final entry in data.entries)
      if (entry.value is Map<String, dynamic>)
        ...flatten(entry.value as Map<String, dynamic>, '$prefix${entry.key}.')
      else
        '$prefix${entry.key}': entry.value as String,
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final en = flatten(readCatalog('en'));
  final es = flatten(readCatalog('es'));
  final placeholders = RegExp(r'\{([^{}]*)\}');

  test('catalogs have matching keys, placeholders and translation links', () {
    expect(es.keys.toSet(), en.keys.toSet());

    for (final key in en.keys) {
      expect(en[key]!.trim(), isNotEmpty, reason: 'en: $key');
      expect(es[key]!.trim(), isNotEmpty, reason: 'es: $key');
      final enArgs = placeholders.allMatches(en[key]!).map((m) => m[1]).toSet();
      final esArgs = placeholders.allMatches(es[key]!).map((m) => m[1]).toSet();
      expect(esArgs, enArgs, reason: key);
      expect(enArgs, isNot(contains('')), reason: 'Use named arguments: $key');
    }

    for (final catalog in [en, es]) {
      for (final text in catalog.values) {
        for (final link in RegExp(r'@:([\w.]+)').allMatches(text)) {
          expect(catalog, contains(link[1]), reason: text);
        }
      }
    }
  });

  test('all literal UI and exception keys exist in both languages', () {
    final keyPattern = RegExp(
      r"'(common|home|player|settings|levels|purchases|validation|errors|content)\.([a-z0-9_]+(?:\.[a-z0-9_]+)*)'",
    );
    for (final file in Directory(
      'lib',
    ).listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      for (final match in keyPattern.allMatches(file.readAsStringSync())) {
        final key = '${match[1]}.${match[2]}';
        expect(en, contains(key), reason: '${file.path}: $key');
        expect(es, contains(key), reason: '${file.path}: $key');
      }
    }
    for (final language in AppLanguage.values) {
      expect(en, contains(language.labelKey));
      expect(es, contains(language.labelKey));
    }
  });

  test(
    'bundled level questions and hints resolve without untranslated prose',
    () {
      final levels = jsonDecode(
        File('assets/data/levels.json').readAsStringSync(),
      ) as List<dynamic>;
      for (final level in levels.cast<Map<String, dynamic>>()) {
        for (final field in ['question', 'hint']) {
          final content = level[field] as Map<String, dynamic>?;
          if (content == null) continue;
          if (content['type'] == 'key') {
            expect(
              en,
              contains(content['value']),
              reason: 'Level ${level['id']}',
            );
            expect(
              es,
              contains(content['value']),
              reason: 'Level ${level['id']}',
            );
          } else if (content['type'] == 'raw') {
            expect(
              content['value'],
              isNot(matches(RegExp(r'[a-zA-Z]'))),
              reason: 'Localize level ${level['id']} $field',
            );
          }
        }
      }
    },
  );

  testWidgets(
    'errors follow the active language and hide unknown diagnostics',
    (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();
      late BuildContext localizedContext;

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('es')],
          startLocale: const Locale('en'),
          fallbackLocale: const Locale('en'),
          saveLocale: false,
          path: 'assets/l10n',
          child: Builder(
            builder: (context) {
              localizedContext = context;
              return MaterialApp(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: [
                  ...context.localizationDelegates,
                  ...GlobalMaterialLocalizations.delegates,
                ],
                home: const SizedBox(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final language in ['en', 'es']) {
        await localizedContext.setLocale(Locale(language));
        await tester.pumpAndSettle();
        final catalog = language == 'en' ? en : es;
        expect(
          errorMessage(
            const UnknownException('errors.progress.save'),
            fallbackKey: 'errors.home',
          ),
          catalog['errors.progress.save'],
        );
        for (final error in [
          StateError('SQLite: private device path'),
          const UnknownException('Internal implementation details'),
          const UnknownException('errors.unknown_key'),
          const UnknownException(''),
          null,
        ]) {
          expect(
            errorMessage(error, fallbackKey: 'errors.home'),
            catalog['errors.home'],
          );
        }
        expect(
          'validation.min_length'.tr(namedArgs: {'min': '3'}),
          contains('3'),
        );
        expect(
          'player.change_name.description'.tr(namedArgs: {'max': '15'}),
          isNot(contains('{max}')),
        );
        expect(
          'content.hints.complexity_range'.tr(),
          startsWith(catalog['content.hints.complexity']!),
        );
      }
    },
  );
}
