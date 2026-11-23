import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ctrl/features/settings.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((_) {
  throw UnimplementedError();
});

final preferencesNotifierProvider =
    StateNotifierProvider<PreferencesNotifier, Preferences>((ref) {
      final repository = ref.read(preferencesRepositoryProvider);

      return PreferencesNotifier(repository)..load();
    });
