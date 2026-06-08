import 'package:ctrl/core/extensions/index.dart';
import 'package:flutter/material.dart';

Future<T?> showAppDialog<T>(
  BuildContext context, {
  required Widget child,
  BoxConstraints? constraints,
  EdgeInsetsGeometry? padding,
  bool fullscreen = false,
  bool dismissible = true,
  bool rootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    useSafeArea: true,
    barrierDismissible: dismissible,
    useRootNavigator: rootNavigator,

    builder: (_) {
      return fullscreen
          ? Dialog.fullscreen(child: child)
          : Dialog(
              clipBehavior: Clip.none,
              insetPadding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24.0),
                ),

                constraints: constraints,
                child: child.padded(padding ?? const EdgeInsets.all(16.0)),
              ),
            );
    },
  );
}
