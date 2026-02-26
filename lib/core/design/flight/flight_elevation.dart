import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';

class FlightElevation {
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get activeShadow => [
    BoxShadow(
      color: kPrimaryColor.withOpacity(0.2),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];
  static List<BoxShadow> get formShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(0, 5), // Đổ bóng xuống dưới
    ),
  ];
}