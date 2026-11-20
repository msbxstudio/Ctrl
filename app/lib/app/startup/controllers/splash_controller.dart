import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/app/startup.dart';

/// Controller for [SplashPage] view.
final class SplashController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
