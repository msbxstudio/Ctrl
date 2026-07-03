import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons/lucide_icons.dart';

final class PopButton extends ConsumerWidget {
  final PopButtonType type;
  final dynamic argument;
  final bool enabled;

  const PopButton({
    super.key,
    this.type = PopButtonType.back,
    this.argument,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Tooltip(
      message: type == PopButtonType.back
          ? 'actions.common.back'.tr()
          : 'actions.common.close'.tr(),

      child: IconButton(
        onPressed: enabled
            ? () => ref.read(goRouterProvider).pop(argument)
            : null,

        // style: theme.iconButtonTheme.style?.copyWith(
        //   splashFactory: NoSplash.splashFactory,
        //   overlayColor: WidgetStateProperty.all(Colors.transparent),
        // ),
        icon: Icon(
          type == PopButtonType.back ? LucideIcons.chevronLeft : LucideIcons.x,
          size: 24.0,
          color: theme.colorScheme.outline,
        ),
      ),
    ).aligned(Alignment.centerRight);
  }
}

enum PopButtonType { back, close }
