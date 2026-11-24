import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:msbx/extensions.dart';

final class HomePageError extends ConsumerWidget {
  ///
  const new({super.key, required this.onRetry, required this.error});

  ///
  final Future<void> Function() onRetry;

  ///
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24.0,

      children: [
        SvgPicture.asset('assets/images/bug.svg', width: 128.0, height: 128.0),

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
    ).padded(const EdgeInsets.symmetric(horizontal: 32.0));
  }
}
