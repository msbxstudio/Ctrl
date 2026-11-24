import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:msbx/exceptions.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';

import 'package:url_launcher/url_launcher.dart';

enum _SettingActionType { tile, link, toggle }

final class SettingOption extends ConsumerWidget {
  const new tile({
    super.key,
    required this.onPressed,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
    this.showIcon = true,
  }) : onChanged = null,
       uri = null,
       value = false,
       _type = _SettingActionType.tile;

  const new link({
    super.key,
    required Uri this.uri,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
    this.showIcon = true,
  }) : onChanged = null,
       onPressed = null,
       value = false,
       _type = _SettingActionType.link;

  const new toggle({
    super.key,
    required this.onChanged,
    required this.value,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
  }) : onPressed = null,
       uri = null,
       showIcon = true,
       _type = _SettingActionType.toggle;

  final void Function()? onPressed;
  final void Function(bool)? onChanged;

  final String title;

  final Uri? uri;

  final Widget? leading;
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  final bool showIcon;
  final bool value;

  final _SettingActionType _type;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48.0),
      child: Material(
        child: InkWell(
          onTap: switch (_type) {
            _SettingActionType.tile => onPressed,
            _SettingActionType.link => () async {
              try {
                final success = await launchUrl(
                  uri!,
                  mode: LaunchMode.externalApplication,
                );

                if (!success) {
                  throw const LaunchException(
                    'No se pudo abrir el enlace solicitado.',
                  );
                }
              } on LaunchException catch (e) {
                showSnackbar(context, e.message);
              }
            },
            _SettingActionType.toggle => null,
          },
          child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.0,

                children: [
                  ?leading,
                  Text(title).expand(),
                  ?trailing,

                  if (showIcon)
                    switch (_type) {
                      _SettingActionType.tile => Icon(
                        LucideIcons.chevronRight,
                        size: 20.0,
                        color: theme.colorScheme.outline,
                      ),
                      _SettingActionType.link => Icon(
                        LucideIcons.arrowUpRight,
                        size: 20.0,
                        color: theme.colorScheme.outline,
                      ),
                      _SettingActionType.toggle => SizedBox(
                        height: 20.0,
                        child: Switch.adaptive(
                          onChanged: onChanged,
                          value: value,

                          activeTrackColor: theme.colorScheme.primary,

                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    },
                ],
              ).padded(
                padding ??
                    const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
              ),
        ),
      ),
    );
  }
}
