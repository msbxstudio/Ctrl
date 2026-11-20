import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/app/startup.dart';

final splashControllerProvider =
    AsyncNotifierProvider.autoDispose<SplashController, void>(
      () => SplashController(),
    );
