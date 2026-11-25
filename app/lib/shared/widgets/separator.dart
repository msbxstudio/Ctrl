import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

final class Separator extends StatelessWidget {
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
  Widget build(BuildContext _) {
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
