import 'package:ctrl/features/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsControllerProvider =
    AsyncNotifierProvider.autoDispose<SettingsController, SettingsState>(
      SettingsController.new,
    );
