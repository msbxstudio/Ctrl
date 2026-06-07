import 'package:ctrl/app/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainControllerProvider = AsyncNotifierProvider.autoDispose(() {
  return MainController();
});

final settingsControllerProvider = AsyncNotifierProvider.autoDispose(() {
  return SettingsController();
});

final splashControllerProvider = AsyncNotifierProvider.autoDispose(() {
  return SplashController();
});
