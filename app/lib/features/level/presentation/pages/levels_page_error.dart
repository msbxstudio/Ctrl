import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/core/utils.dart';
import 'package:msbx/extensions.dart';

final class LevelsPageError extends ConsumerWidget {
  const new({
    super.key,
    required this.onRetry,
    required this.error,
    this.stackTrace,
  });

  final void Function() onRetry;
  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return Text(errorMessage(error, fallbackKey: 'errors.levels.load'))
        .centered();
  }
}
