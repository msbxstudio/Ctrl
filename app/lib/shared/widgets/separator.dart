import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class Separator extends ConsumerWidget {
  final double opacity;
  final double verticalIndent;
  final double horizontalIndent;

  const Separator({
    super.key,
    this.opacity = 0.25,
    this.verticalIndent = 16.0,
    this.horizontalIndent = 0.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
