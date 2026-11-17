import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons/lucide_icons.dart';

final class PopButton extends ConsumerWidget {
  final dynamic argument;
  final bool enabled;

  final _PopButtonType _type;

  const PopButton.back({super.key, this.argument, this.enabled = true})
    : _type = _PopButtonType.back;

  const PopButton.close({super.key, this.argument, this.enabled = true})
    : _type = _PopButtonType.close;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Tooltip(
      message: _type == _PopButtonType.back
          ? 'actions.common.back'.tr()
          : 'actions.common.close'.tr(),

      child: IconButton(
        onPressed: enabled
            ? () => ref.read(goRouterProvider).pop(argument)
            : null,

        icon: Icon(
          _type == _PopButtonType.back
              ? LucideIcons.chevronLeft
              : LucideIcons.x,
          size: 24.0,
          color: theme.colorScheme.outline,
        ),
      ),
    ).aligned(Alignment.centerRight);
  }
}

enum _PopButtonType { back, close }
