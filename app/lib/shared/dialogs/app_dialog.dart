import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:msbx/msbx.dart';

Future<T?> showAppDialog<T>(
  BuildContext context, {
  required Widget child,
  BoxConstraints? constraints,
  EdgeInsetsGeometry? padding,
  Color? color,
  bool fullscreen = false,
  bool dismissible = true,
  bool useSafeArea = true,
  bool rootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    useSafeArea: useSafeArea,
    barrierDismissible: dismissible,
    useRootNavigator: rootNavigator,

    builder: (_) {
      return fullscreen
          ? Dialog.fullscreen(
              insetAnimationCurve: Curves.decelerate,
              insetAnimationDuration: const Duration(seconds: 2),
              backgroundColor:
                  color ??
                  Theme.of(context).colorScheme.surfaceContainerHighest,

              child: child.padded(padding ?? const EdgeInsets.all(16.0)),
            )
          : Dialog(
              clipBehavior: Clip.none,
              insetPadding: EdgeInsets.zero,

              child: Container(
                decoration: BoxDecoration(
                  color:
                      color ??
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24.0),
                ),

                constraints: constraints,
                child: child.padded(padding ?? const EdgeInsets.all(16.0)),
              ),
            );
    },
  );
}
