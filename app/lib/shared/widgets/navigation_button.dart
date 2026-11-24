import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:msbx/extensions.dart';

import 'package:ctrl/app/router.dart';

/// ...
enum _NavigationButtonType {
  /// ...
  back,

  /// ...
  close,
}

final class NavigationButton<T extends Object> extends ConsumerWidget {
  const NavigationButton.back({super.key, this.result})
    : _type = _NavigationButtonType.back;

  const NavigationButton.close({super.key, this.result})
    : _type = _NavigationButtonType.close;

  final T? result;

  final _NavigationButtonType _type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Tooltip(
      message: _type == _NavigationButtonType.back
          ? 'actions.common.back'.tr()
          : 'actions.common.close'.tr(),

      child: IconButton(
        onPressed: () {
          ref.read(routerProvider).pop(result);
        },

        icon: Icon(
          switch (_type) {
            _NavigationButtonType.back => LucideIcons.chevronLeft,
            _NavigationButtonType.close => LucideIcons.x,
          },

          color: theme.colorScheme.outline,
          size: 24.0,
        ),
      ),
    ).aligned(Alignment.centerRight);
  }
}
