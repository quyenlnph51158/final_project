import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_layout.dart';

class SharedAppStyle{
  static TextStyle titleSection(BuildContext context) =>
      TextStyle(
        fontSize: context.sp(20),
        fontWeight: FontWeight.bold,
      );

  static TextStyle titleHeader(BuildContext context) => TextStyle(
      color: kHeaderTextColor,
      fontSize: context.sp(24),
      fontWeight: FontWeight.bold,
      height: 1.3);
}