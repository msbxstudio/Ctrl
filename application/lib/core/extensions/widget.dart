import 'package:flutter/material.dart';

extension WidgetX on Widget {
  Widget dismissKeyboard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: this,
    );
  }

  Widget expand({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  Widget sized({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  Widget centered() {
    return Center(child: this);
  }

  Widget padded(EdgeInsetsGeometry margin) {
    return Padding(padding: margin, child: this);
  }

  Widget aligned(
    AlignmentGeometry aligment, {
    double? widthFactor,
    double? heightFactor,
  }) {
    return Align(
      alignment: aligment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  Widget constrained({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
      child: this,
    );
  }
}
