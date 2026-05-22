import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

enum FlightTab { flight, hotel, tour }

class FlightSize {
  // ======================== LOGO & ICONS (Dùng icon/sp/rw) ========================

  // Logo chính (~40px)
  static double logoMain(BuildContext context) => context.icon(40);

  // Logo nhỏ và icon
  static double logoSmall(BuildContext context) => context.icon(24);

  static double iconTab(BuildContext context) => context.icon(20);

  static double iconTimelineDot(BuildContext context) => context.icon(12);

  static double iconTimer(BuildContext context) => context.icon(16);

  static double iconSmall(BuildContext context) => context.icon(16);

  static double iconSizeMedium(BuildContext context) => context.icon(24);

  static double iconTabSize(BuildContext context) => context.icon(24);

  static double iconSizeSmall(BuildContext context) => context.icon(16);

  static double iconSize(BuildContext context) => context.icon(22);

  static double iconInputSize(BuildContext context) => context.icon(20);

  static double featureIconSize(BuildContext context) => context.icon(40);

  static double searchIconSize(BuildContext context) => context.icon(20);

  static double filterIconSize(BuildContext context) => context.icon(20);

  // ======================== CHIỀU CAO & KHOẢNG CÁCH DỌC (Dùng rh) ========================

  static double btnSearchHeight(BuildContext context) => context.rh(50).clamp(48.0, 55.0);

  static double btnContinueHeight(BuildContext context) => context.rh(48).clamp(45.0, 55.0);

  static double btnSelectHeight(BuildContext context) => context.rh(45);

  static double btnConfirmHeight(BuildContext context) => context.rh(50);

  static double btnUnderstandHeight(BuildContext context) => context.rh(48);

  static double btnSmallHeight(BuildContext context) => context.rh(40);

  static double serviceCardHeight(BuildContext context) => context.rh(240);

  static double destinationCardHeight(BuildContext context) => context.rh(200);

  static double featureCardHeight(BuildContext context) => context.rh(200);

  static double cheapFlightImageHeight(BuildContext context) => context.rh(180);

  static double headerBackgroundHeight(BuildContext context) => context.rh(250);

  static double formTopOffset(BuildContext context) => context.rh(48);

  static double bottomSheetHeight(BuildContext context) => context.rh(730);

  static double airportModalHeight(BuildContext context) => context.rh(680);

  static double passengerModalHeight(BuildContext context) => context.rh(680);

  static double inputHeight(BuildContext context) => context.rh(44);

  static double dragHandleHeight(BuildContext context) => context.rh(5);

  static double searchFormHeight(BuildContext context, dynamic tab) {
    // Wrap giá trị pixel thiết kế vào rh()
    return (tab == FlightTab.flight) ? context.rh(530) : context.rh(370);
  }

  // ======================== CHIỀU RỘNG & KHOẢNG CÁCH NGANG (Dùng rw) ========================

  static double fareCardWidth(BuildContext context) => context.rw(290);

  static double classCardWidthPercent(BuildContext context) => context.rw(280);

  static double tabIndicatorWidth(BuildContext context) => context.rw(20);

  static double destinationIndicatorWidth(BuildContext context) => context.rw(50);

  static double dragHandleWidth(BuildContext context) => context.rw(45);

  // ======================== TYPOGRAPHY (Dùng sp) ========================

  static double filterTextSize(BuildContext context) => context.sp(14);

  // ======================== PADDING & MARGIN (Dùng rw/rh/padding) ========================

  static double horizontalPadding(BuildContext context) => context.padding;

  static double verticalPadding(BuildContext context) => context.rh(12);

  static double elementSpacing(BuildContext context) => context.rw(10);

  static double inputContentPaddingV(BuildContext context) => context.rh(12);

  static double inputContentPaddingH(BuildContext context) => context.rw(16);

  // ======================== CONSTANTS (Scale nhẹ cho ổn định) ========================

  static double tabIndicatorHeight(BuildContext context) => context.rh(3);

  static double destinationIndicatorHeight(BuildContext context) => context.rh(3);

  static double loadingIndicatorWidth(BuildContext context) => context.rw(3);

  static double iconFlightSmall(BuildContext context) => context.icon(18);

  static double dividerThin(BuildContext context) => context.rh(1);

  static double dashLength(BuildContext context) => context.rw(6);

  static double dashGap(BuildContext context) => context.rw(4);

  static const double destinationAspectRatio = 2.0; // Tỉ lệ khung hình giữ nguyên const
}