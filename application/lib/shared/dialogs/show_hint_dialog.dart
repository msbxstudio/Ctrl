import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/shared/widgets/separator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'show_app_dialog.dart';

Future<void> showHintDialog(
  BuildContext context, {
  required String hint,
  bool dismissible = true,
  bool rootNavigator = true,
  bool scrollControlled = true,
}) {
  final width = MediaQuery.of(context).size.width * 0.80;
  final height = MediaQuery.of(context).size.height * 0.45;

  return showAppDialog(
    context,
    constraints: BoxConstraints(
      maxWidth: width,
      minWidth: width,
      maxHeight: height,
      minHeight: height,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Text(
          hint,
          style: Theme.of(context).textTheme.headlineSmall,
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

            child: Text('actions.common.ok'.tr()),
          ).aligned(Alignment.center),
        ].divide(const SizedBox(height: 16.0)),
      ],
    ),
  );
}
