import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:msbx/extensions.dart';

Future<T?> showAppModal<T>(
  BuildContext context, {
  required Widget child,
  BoxConstraints? constraints,
  bool dismissible = true,
  bool useSafeArea = false,
  bool rootNavigator = true,
  bool scrollControlled = true,
}) {
  final theme = Theme.of(context);

  return showModalBottomSheet<T>(
    context: context,

    constraints: constraints,

    useSafeArea: useSafeArea,
    isDismissible: dismissible,
    useRootNavigator: rootNavigator,
    isScrollControlled: scrollControlled,

    backgroundColor: Colors.transparent,
    elevation: 0.0,

    builder: (_) {
      return Material(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        clipBehavior: Clip.antiAlias,
        elevation: 1.0,

        color: theme.colorScheme.surfaceContainerHighest,
        child: SafeArea(
          minimum: EdgeInsets.only(top: dismissible ? 0.0 : 16.0, bottom: 16.0),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              if (dismissible)
                Container(
                      width: 48.0,
                      height: 6.0,

                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                    )
                    .aligned(Alignment.center)
                    .padded(const EdgeInsets.only(top: 16.0, bottom: 12.0)),
              child,
            ],
          ),
        ),
      );
    },
  );
}
