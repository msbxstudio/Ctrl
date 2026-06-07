import 'package:ctrl/core/extensions/index.dart';
import 'package:flutter/material.dart';

Future<T?> showAppDialog<T>(
  BuildContext context, {
  required String title,
  String? description,
  required String primaryButtonText,
  String? secondaryButtonText,
  bool dismissible = true,
  bool rootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    useRootNavigator: rootNavigator,

    builder: (_) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),

        title: Text(title),
        content: description != null ? Text(description) : null,

        actions: [
          TextButton(onPressed: () async {}, child: Text(primaryButtonText)),
          if (secondaryButtonText != null)
            TextButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop<bool>(false);
              },

              child: Text(secondaryButtonText),
            ),
        ].divide(const SizedBox(width: 8.0)),
      );
    },
  );
}
