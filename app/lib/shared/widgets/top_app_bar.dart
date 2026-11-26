import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// A customizable top app bar with content-driven height.
final class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const new({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.bottom,
    this.toolbarHeight,
    this.bottomHeight,
    this.backgroundColor,
    this.centerTitle = true,
    this.borderRadius = BorderRadius.zero,
  }) : assert(
         toolbarHeight == null ||
             (toolbarHeight >= 0.0 && toolbarHeight < double.infinity),
       ),
       assert(
         bottomHeight == null ||
             (bottomHeight >= 0.0 && bottomHeight < double.infinity),
       );

  /// The primary content displayed in the toolbar.
  final Widget? title;

  /// The widget displayed at the start of the toolbar.
  final Widget? leading;

  /// The widget displayed at the end of the toolbar.
  final Widget? trailing;

  /// The widget displayed below the toolbar.
  final Widget? bottom;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The toolbar height.
  ///
  /// If null, the height is determined by its children.
  final double? toolbarHeight;

  /// The bottom widget height.
  ///
  /// If null, the height is determined by the bottom widget.
  final double? bottomHeight;

  /// Whether the title is centered horizontally.
  final bool centerTitle;

  /// The corner radius of the app bar.
  final BorderRadiusGeometry borderRadius;

  bool get _hasToolbar {
    return leading != null || title != null || trailing != null;
  }

  @override
  Size get preferredSize {
    final toolbar = _hasToolbar ? toolbarHeight : 0.0;
    final footer = bottom != null ? bottomHeight : 0.0;

    if (toolbar == null || footer == null) {
      return const Size.fromHeight(double.maxFinite);
    }

    return Size.fromHeight(toolbar + footer);
  }

  // @override
  // Size get preferredSize {
  //   if (!_hasToolbar && bottom == null) {
  //     return Size.zero;
  //   }

  //   if ((_hasToolbar && toolbarHeight == null) ||
  //       (bottom != null && bottomHeight == null)) {
  //     return const Size.fromHeight(double.maxFinite);
  //   }

  //   return Size.fromHeight(
  //     (_hasToolbar ? toolbarHeight! : 0.0) +
  //         (bottom != null ? bottomHeight! : 0.0),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius,
      ),

      child: SafeArea(
        top: Scaffold.maybeOf(context)?.widget.primary ?? false,
        bottom: false,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            if (_hasToolbar)
              SizedBox(
                width: double.infinity,
                height: toolbarHeight,

                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.loose,

                  children: [
                    if (leading != null)
                      Align(
                        heightFactor: 1.0,
                        alignment: AlignmentDirectional.centerStart,
                        child: leading!,
                      ),

                    if (title != null)
                      Align(
                        heightFactor: 1.0,
                        alignment: centerTitle
                            ? AlignmentDirectional.center
                            : AlignmentDirectional.centerStart,
                        child: title!,
                      ),

                    if (trailing != null)
                      Align(
                        heightFactor: 1.0,
                        alignment: AlignmentDirectional.centerEnd,
                        child: trailing!,
                      ),
                  ],
                ),
              ),

            if (bottom != null)
              SizedBox(
                height: bottomHeight,
                child: bottom!,
              ),
          ],
        ),
      ),
    );
  }
}
