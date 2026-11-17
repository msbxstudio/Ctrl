import 'package:ctrl/core/utils/index.dart';
import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context,
  String message, {
  SnackBarBehavior? behavior = SnackBarBehavior.floating,
  EdgeInsetsGeometry? margin,
  bool loading = false,
  int duration = 2,
}) {
  final width = MediaQuery.of(context).size.width;
  final remaining = width - Breakpoints.small;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: behavior,
      width: remaining > 0
          ? Breakpoints.small - (margin?.horizontal ?? 0.0)
          : null,
      content: Row(
        children: [
          if (loading)
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator.adaptive(),
              ),
            ),
          Expanded(child: Text(message, softWrap: true, maxLines: null)),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}
