import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

final class DragHandle extends StatelessWidget {
  const new({
    super.key,
    this.color,
    this.margin,
    this.width = 48.0,
    this.height = 4.0,
  });

  final Color? color;

  final EdgeInsetsGeometry? margin;

  final double width;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Container(
          width: width,
          height: height,

          decoration: BoxDecoration(
            color:
                color ??
                Theme.of(context).colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.6),
            borderRadius: const BorderRadius.all(Radius.circular(100.0)),
          ),
        ),
      ),
    );
  }
}
