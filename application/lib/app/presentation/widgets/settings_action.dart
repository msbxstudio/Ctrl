// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:ctrl/core/exceptions/launch_exception.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

final class SettingsAction extends ConsumerWidget {
  final void Function()? onPressed;
  final void Function(bool)? onChanged;

  final String title;
  final String type;

  final Uri uri;

  final Widget? leading;
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  final bool showIcon;
  final bool value;

  SettingsAction.tile({
    super.key,
    required this.onPressed,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
    this.showIcon = true,
  }) : onChanged = null,
       uri = Uri(),
       value = false,
       type = 'tile';

  SettingsAction.link({
    super.key,
    required this.uri,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
    this.showIcon = true,
  }) : onChanged = null,
       onPressed = null,
       value = false,
       type = 'link';

  SettingsAction.toggle({
    super.key,
    required this.onChanged,
    required this.value,
    required this.title,
    this.leading,
    this.trailing,
    this.padding,
  }) : onPressed = null,
       uri = Uri(),
       showIcon = true,
       type = 'toggle';

  @override
  Widget build(BuildContext context, WidgetRef _) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48.0),
      child: Material(
        child: InkWell(
          onTap: switch (type) {
            'tile' => onPressed,
            'link' => () async {
              try {
                final success = await launchUrl(
                  uri,
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
            _ => null,
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
                    switch (type) {
                      'tile' => Icon(
                        LucideIcons.chevronRight,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      'link' => Icon(
                        LucideIcons.arrowUpRight,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      _ => SizedBox(
                        height: 20.0,
                        child: Switch.adaptive(
                          onChanged: onChanged,
                          value: value,

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
