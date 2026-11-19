import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final class Separator extends ConsumerWidget {
  const new({
    super.key,
    this.opacity = 0.25,
    this.verticalIndent = 16.0,
    this.horizontalIndent = 0.0,
  });

  final double opacity;
  final double verticalIndent;
  final double horizontalIndent;

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return Opacity(
      opacity: opacity,
      child: Divider(
        height: (verticalIndent * 2) + 1.0,
        thickness: 1.0,

        indent: horizontalIndent,
        endIndent: horizontalIndent,
      ),
    );
  }
}
