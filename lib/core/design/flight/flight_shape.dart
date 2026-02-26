import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

class FlightShape {
  // Bo góc co giãn nhẹ theo chiều rộng màn hình
  static BorderRadius borderRadiusSmall(BuildContext context) =>
      BorderRadius.circular(context.sp(8));

  static BorderRadius borderRadiusLarge(BuildContext context) =>
      BorderRadius.circular(context.sp(16));
  static const double borderThick = 2.0;
  static const double borderThin = 1.0;

  static double radiusLarge(BuildContext context) => context.sp(12.0);
  static BorderRadius borderRadiusBottomSheet = const BorderRadius.vertical(
    top: Radius.circular(24.0),
  );
  static OutlineInputBorder selectionField = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  );
  static OutlineInputBorder inputOutlineBorder(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: Color(0xFFE4E7E9)), // kBorderColor
  );
  static const double bottomSheetRadiusValue = 20.0;

  static const ShapeBorder bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(bottomSheetRadiusValue)),
  );
}
