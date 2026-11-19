import 'package:flutter/widgets.dart';

bool isMobile(BuildContext context) {
  return _getWidth(context) < 600;
}

bool isTablet(BuildContext context) {
  return _getWidth(context) >= 600 && _getWidth(context) < 1024;
}

bool isDesktop(BuildContext context) {
  return _getWidth(context) >= 1024;
}

double _getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
