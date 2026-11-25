import 'dart:math';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:msbx/extensions.dart';

import 'package:ctrl/shared/dialogs.dart';
import 'package:ctrl/shared/widgets.dart';

Future<void> showHintDialog(
  BuildContext context, {
  required String hint,
  bool dismissible = true,
  bool rootNavigator = true,
  bool scrollControlled = true,
}) {
  final size = MediaQuery.of(context).size;

  final width = min(size.width * 0.80, 400.0);
  // final height = min(size.width * 0.45, 400.0);

  return showAppDialog(
    context,

    constraints: BoxConstraints(
      maxWidth: width,
      minWidth: width,
      maxHeight: width,
      minHeight: width,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Text(
          hint,

          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(height: 1.5),
        ).centered().expand(),

        ...[
          const Separator(verticalIndent: 0.0),

          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            style: Theme.of(context).textButtonTheme.style?.copyWith(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              ),
            ),

            child: Text('common.actions.close'.tr()),
          ).aligned(Alignment.center),
        ].divide(const SizedBox(height: 16.0)),
      ],
    ),
  );
}
