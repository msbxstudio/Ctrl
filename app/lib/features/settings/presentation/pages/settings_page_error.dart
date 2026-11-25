import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:msbx/extensions.dart';

/// Represents the error state of the settings page.
///
/// Holds diagnostic information and an asynchronous retry callback
/// for recovering from a failed loading operation.
final class SettingsPageError extends ConsumerWidget {
  /// Creates an error state with the associated [error] and retry callback.
  const new({
    super.key,
    required this.onRetry,
    required this.error,
    this.stackTrace,
  });

  /// The asynchronous callback intended to retry loading the settings.
  final Future<void> Function() onRetry;

  /// The error associated with the failed loading operation.
  final Object error;

  /// The stack trace associated with [error].
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24.0,

        children: [
          SvgPicture.asset(
            'assets/images/bug.svg',
            width: 128.0,
            height: 128.0,
          ),

          Text(
            'Ocurrió un error',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),

          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),

          FilledButton.icon(
            onPressed: () async => await onRetry(),

            label: const Text('Intentar de nuevo'),
            icon: Icon(LucideIcons.rotateCcw),
          ),
        ],
      ).padded(const EdgeInsets.symmetric(horizontal: 32.0)),
    );
  }
}
