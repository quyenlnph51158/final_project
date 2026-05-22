import 'package:flutter/material.dart';

extension ResponsiveLayout on BuildContext {
  MediaQueryData get _media => MediaQuery.of(this);

  double get screenWidth => _media.size.width;
  double get screenHeight => _media.size.height;

  static const double _baseWidth = 375;
  static const double _baseHeight = 812;

  double get _widthScale =>
      (screenWidth / _baseWidth).clamp(0.85, 1.2);

  double get _heightScale =>
      (screenHeight / _baseHeight).clamp(0.85, 1.1);

  bool get isSmallPhone => screenWidth < 360;

  /// scale theo thiết kế
  double rw(double size) => size * _widthScale;
  double rh(double size) => size * _heightScale;

  double sp(double size) {
    final textScale = _media.textScaleFactor.clamp(1.0, 1.05);
    return (size * _widthScale * textScale).clamp(10.0, 40.0);
  }

  double get padding => rw(isSmallPhone ? 12 : 16);

  double get radius => rw(isSmallPhone ? 10 : 14);

  double icon(double size) => size * _widthScale;
}