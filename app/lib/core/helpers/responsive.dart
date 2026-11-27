import 'dart:math';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:msbx/config.dart';

/// Computes the horizontal padding required to center content
/// within a maximum width while preserving a minimum inset.
double responsiveHorizontalPadding(
  BuildContext context, {
  double maxWidth = Breakpoints.small,
  double minPadding = 16.0,
}) {
  final size = MediaQueryData.fromView(View.of(context)).size;

  return max((size.width - maxWidth) / 2.0, minPadding);
}
