import 'dart:async';

import 'package:flutter/foundation.dart';

final class Debugger {
  static void log(String message) {
    if (kDebugMode) {
      debugPrint('[LOG] $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARNING] $message');
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
    }
  }

  static void ensure(bool condition, [String? message]) {
    assert(condition, message ?? 'Assertion failed');
  }

  static Future<T> time<T>(String label, FutureOr<T> Function() action) async {
    final sw = Stopwatch()..start();

    try {
      return await action();
    } finally {
      sw.stop();
      if (kDebugMode) {
        debugPrint('[TIME] $label -> ${sw.elapsedMilliseconds} ms');
      }
    }
  }
}
