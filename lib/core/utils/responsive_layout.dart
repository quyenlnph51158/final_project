import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 350;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
          MediaQuery.sizeOf(context).width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

extension ResponsiveContext on BuildContext {
  bool get isSmallMobile => ResponsiveLayout.isSmallMobile(this);
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  double get width => ResponsiveLayout.screenWidth(this);
  double get height => ResponsiveLayout.screenHeight(this);

  /// Width percentage
  double wp(double percent) => width * (percent / 100);

  /// Height percentage
  double hp(double percent) => height * (percent / 100);

  /// Scalable text size
  double sp(double baseSize) {
    final media = MediaQuery.of(this);
    const baseWidth = 375.0;

    double scale = media.size.width / baseWidth;
    scale = scale.clamp(0.8, 2.0);

    double finalSize = baseSize * scale * media.textScaleFactor;

    return finalSize.clamp(8.0, 200.0); // tránh quá nhỏ hoặc quá lớn
  }
}