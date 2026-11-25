import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/extensions.dart';

/// Displays the error state of the level page.
///
/// Presents a localized error message when level data cannot be loaded.
final class LevelPageError extends ConsumerWidget {
  /// Creates an error state with diagnostic information and a retry callback.
  const new({
    super.key,
    required this.onRetry,
    required this.error,
    this.stackTrace,
  });

  /// The callback intended to retry loading the level data.
  final void Function() onRetry;

  /// The error associated with the failed loading operation.
  final Object error;

  /// The stack trace associated with [error], if available.
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return Text('levels.error_loading'.tr()).centered();
  }
}
