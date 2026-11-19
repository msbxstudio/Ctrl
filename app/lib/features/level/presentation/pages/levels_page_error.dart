import 'package:ctrl/core/extensions/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class LevelsPageError extends ConsumerWidget {
  final void Function() onRetry;
  final Object error;
  final StackTrace? stackTrace;

  const LevelsPageError({
    super.key,
    required this.onRetry,
    required this.error,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context, WidgetRef _) {
    return Text('levels.error_loading_all'.tr()).centered();
  }
}
