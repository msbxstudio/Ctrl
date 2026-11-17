import 'dart:async';

import 'package:flutter/foundation.dart';

/// A utility class for logging and debugging purposes.
final class Debugger {
  /// Logs a message to the console if in debug mode or if [showInRelease] is true.
  static void log(String message, {bool showInRelease = false}) {
    if (kDebugMode || showInRelease) {
      debugPrint('[LOG] $message');
    }
  }

  /// Logs a warning message to the console if in debug mode or if [showInRelease] is true.
  static void warning(String message, {bool showInRelease = false}) {
    if (kDebugMode || showInRelease) {
      debugPrint('[WARNING] $message');
    }
  }

  /// Logs an error message to the console if in debug mode or if [showInRelease] is true.
  static void error(String message, {bool showInRelease = false}) {
    if (kDebugMode || showInRelease) {
      debugPrint('[ERROR] $message');
    }
  }

  /// Asserts that a condition is true. If the condition is false, it throws an [AssertionError] with the provided [message].
  static void ensure(bool condition, [String? message]) {
    assert(condition, message ?? 'Assertion failed');
  }

  /// Measures the time taken to execute a given [action] and logs the elapsed time with the provided [label].
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
