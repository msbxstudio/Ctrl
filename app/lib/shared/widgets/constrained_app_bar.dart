import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/services.dart';

/// A Material app bar with configurable layout constraints.
final class ConstrainedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a constrained Material app bar.
  const new({
    super.key,
    this.constraints = const BoxConstraints.expand(),
    this.alignment = Alignment.topCenter,
    this.leading,
    this.title,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarHeight,
    this.leadingWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.surfaceTintColor,
    this.shadowColor,
    this.elevation,
    this.shape,
    this.actionsPadding,
    this.primary = true,
  });

  /// The layout constraints applied to the app bar.
  final BoxConstraints constraints;

  /// The alignment within the available space.
  final AlignmentGeometry alignment;

  /// A widget displayed before the title.
  final Widget? leading;

  /// The primary widget displayed in the toolbar.
  final Widget? title;

  /// The widgets displayed after the title.
  final List<Widget>? actions;

  /// A widget displayed below the toolbar.
  final PreferredSizeWidget? bottom;

  /// Whether the title is centered.
  final bool? centerTitle;

  /// The spacing around the title.
  final double? titleSpacing;

  /// The height of the toolbar.
  final double? toolbarHeight;

  /// The width allocated to the leading widget.
  final double? leadingWidth;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The default color of the toolbar's text and icons.
  final Color? foregroundColor;

  /// The color used to indicate elevation.
  final Color? surfaceTintColor;

  /// The color of the app bar's shadow.
  final Color? shadowColor;

  /// The elevation of the app bar.
  final double? elevation;

  /// The shape of the app bar's material.
  final ShapeBorder? shape;

  final EdgeInsetsGeometry? actionsPadding;

  /// Whether the app bar accounts for the system status bar.
  final bool primary;

  @override
  Size get preferredSize {
    return _buildAppBar().preferredSize;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: constraints,
        child: _buildAppBar(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,

      leading: leading,
      title: title,
      actions: actions,
      bottom: bottom,

      centerTitle: centerTitle,
      primary: primary,

      actionsPadding: actionsPadding,
      titleSpacing: titleSpacing,

      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,

      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,

      elevation: elevation,
      shape: shape,
    );
  }
}
