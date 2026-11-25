import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:msbx/extensions.dart';

import 'package:ctrl/core/utils.dart';

final class HomePageError extends ConsumerWidget {
  ///
  const new({
    super.key,
    required this.onRetry,
    required this.error,
    this.stackTrace,
  });

  ///
  final Future<void> Function() onRetry;

  ///
  final Object error;

  ///
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
            'errors.load_title'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),

          Text(
            errorMessage(error, fallbackKey: 'errors.home'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),

          FilledButton.icon(
            onPressed: () async => await onRetry(),

            label: Text('common.actions.retry'.tr()),
            icon: const Icon(LucideIcons.rotateCcw),
          ),
        ],
      ).padded(const EdgeInsets.symmetric(horizontal: 32.0)),
    );
  }
}
