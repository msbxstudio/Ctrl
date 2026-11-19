import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msbx/msbx.dart';

final class SettingsPageError extends ConsumerWidget {
  ///
  const new({super.key, required this.onRetry, required this.error});

  /// ...
  final Future<void> Function() onRetry;

  /// ...
  final Object error;

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 24.0,

      children: [
        Text(error.toString(), textAlign: TextAlign.center),

        FilledButton(
          onPressed: () async => await onRetry(),
          child: const Text('Intentar de nuevo'),
        ),
      ],
    ).padded(const EdgeInsets.symmetric(horizontal: 32.0));
  }
}
