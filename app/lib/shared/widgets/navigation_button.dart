import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:msbx/extensions.dart';

import 'package:ctrl/app/router.dart';

enum _NavigationButtonType {
  ///
  pop,

  ///
  custom,
}

final class NavigationButton<T extends Object> extends ConsumerWidget {
  const new({
    super.key,
    required this.onPressed,
    required this.child,
    this.result,
    this.tooltip,
  }) : _type = _NavigationButtonType.custom;

  const new back({
    super.key,
    this.result,
  }) : onPressed = null,
       child = const Icon(LucideIcons.chevronLeft),
       tooltip = 'actions.common.back',
       _type = _NavigationButtonType.pop;

  const new close({
    super.key,
    this.result,
  }) : onPressed = null,
       child = const Icon(LucideIcons.x),
       tooltip = 'actions.common.close',
       _type = _NavigationButtonType.pop;

  final VoidCallback? onPressed;

  final Widget child;

  final T? result;

  final String? tooltip;

  final _NavigationButtonType _type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip?.tr() ?? '',

      child: IconButton(
        onPressed: _type == _NavigationButtonType.pop
            ? () {
                ref.read(routerProvider).pop(result);
              }
            : onPressed,

        style: theme.iconButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.all(
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
          ),
        ),

        icon: Theme(
          data: theme.copyWith(
            iconTheme: IconThemeData(
              color: theme.colorScheme.onSecondaryContainer,
              size: 24.0,
            ),
          ),

          child: child,
        ),
      ),
    ).aligned(Alignment.centerRight);
  }
}
