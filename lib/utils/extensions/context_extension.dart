import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get _mediaQueryData => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
  double get screenWidth => _mediaQueryData.size.width;
  double get screenHeight => _mediaQueryData.size.height;
}
