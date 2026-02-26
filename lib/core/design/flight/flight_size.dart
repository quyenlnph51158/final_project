import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../constants/colors.dart';

class FlightSize {
  static double logoMain(BuildContext context) => context.wp(10);

  static double logoSmall(BuildContext context) => context.sp(24.0);

  static double iconTab(BuildContext context) => 20.0;

  static double iconTimelineDot(BuildContext context) => 12;

  static double iconTimer(BuildContext context) => context.sp(16);
  static const double tabIndicatorHeight = 3.0;
  static const double tabIndicatorWidth = 20.0;

  // Chiều cao nút bấm nên dùng hp (height percentage) để dễ bấm
  static double btnSelectHeight(BuildContext context) => 45;
  static const double classCardWidthPercent = 75.0;

  static double iconSmall(BuildContext context) => context.sp(16);

  static double fareCardWidth(BuildContext context) => context.wp(78.0);

  static double btnContinueHeight(BuildContext context) => context.hp(5.5);

  static double serviceCardHeight(BuildContext context) =>
      context.hp(30.0); // Thay cho 250 cứng
  static double btnSearchHeight(BuildContext context) => context.hp(6);

  static double iconSizeMedium(BuildContext context) => context.sp(24);

  static double destinationCardHeight(BuildContext context) =>
      context.hp(25.0); // Thay cho 200px
  static double destinationIndicatorWidth = 50.0;
  static double destinationIndicatorHeight = 3.0;

  static double iconTabSize(BuildContext context) => context.sp(24);

  static double featureCardHeight(BuildContext context) =>
      context.hp(25.0); // Thay cho 200.0
  static double featureIconSize(BuildContext context) =>
      context.sp(40); // Icon lớn trung tâm
  static double cheapFlightImageHeight(BuildContext context) =>
      context.hp(22.0);

  static double btnSmallHeight(BuildContext context) => context.hp(5.0);

  static double iconSizeSmall(BuildContext context) => context.sp(16);

  static double headerBackgroundHeight(BuildContext context) =>
      context.hp(30.0);

  static double searchFormHeight(dynamic tab) {
    // Giả sử FlightTab.flight là tab tìm kiếm chính
    return (tab == FlightTab.flight) ? 530.0 : 370.0;
  }

  static const double formTopOffset = 30.0;
  static const double destinationAspectRatio = 2.0;
  static const double loadingIndicatorWidth = 3.0;
  static double iconFlightSmall = 18.0;
  static double dividerThin = 1.0;
  static double dashLength = 6.0;
  static double dashGap = 4.0;
  static double bottomSheetHeight(BuildContext context) => context.hp(90.0);
  static double dragHandleWidth = 45.0;
  static double dragHandleHeight = 5.0;
  static double inputHeight = 44.0;
  static double btnUnderstandHeight = 48.0;
  static double airportModalHeight(BuildContext context) => context.hp(85.0);
  static double searchIconSize = 20.0;
  static double passengerModalHeight(BuildContext context) => context.hp(85.0);
  static double btnConfirmHeight(BuildContext context) => context.hp(6.0);
  static double iconInputSize(BuildContext context) => context.sp(20);
  static double inputContentPaddingV = 12.0;
  static double inputContentPaddingH = 16.0;
  static double filterIconSize(BuildContext context) => context.sp(20.0);
  static double filterTextSize(BuildContext context) => context.sp(14.0);
  static double horizontalPadding(BuildContext context) => context.wp(4);
  static double verticalPadding(BuildContext context) => context.sp(12);
  static double elementSpacing(BuildContext context) => context.wp(2.5);
}
