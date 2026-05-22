import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

class FlightLayoutSpacing {
  // --- Các giá trị Double (Chuyển từ % sang rh/rw) ---

  static double cardMarginV(BuildContext context) => context.rh(8.0);

  static double paddingAll(BuildContext context) => context.padding; // rw chuẩn toàn app

  static double gapMedium(BuildContext context) => context.rw(16.0);

  static double gapSmall(BuildContext context) => context.rw(8.0);

  static double timelineIndent(BuildContext context) => context.rw(56.0);

  static double timelineGap(BuildContext context) => context.rw(12.0);

  static double segmentGap(BuildContext context) => context.rh(12.0);

  static double featureBottomPadding(BuildContext context) => context.rh(6.0);

  static double gapIcon(BuildContext context) => context.rw(8.0);

  static double featurePaddingBottom(BuildContext context) => context.rh(6.0);

  static double tabGap(BuildContext context) => context.rw(24.0);

  static double timelineTimeGap(BuildContext context) => context.rh(24.0);

  static double overlayPadding(BuildContext context) => context.rw(20.0);

  static double destinationPadding(BuildContext context) => context.rw(4.0);

  static double destinationContentOffset(BuildContext context) => context.rh(10.0);

  static double iconWrapperPadding(BuildContext context) => context.rw(12.0);

  static double cardPadding(BuildContext context) => context.rw(12.0);

  static double iconTextGap(BuildContext context) => context.rw(4.0);

  static double headerHorizontalPadding(BuildContext context) => context.padding;

  static double gridHorizontalPadding(BuildContext context) => context.padding;

  static double gridGap(BuildContext context) => context.rw(12.0);

  static double gapInputHorizontal(BuildContext context) => context.rw(12.0);

  static double screenHorizontalPadding(BuildContext context) => context.padding;

  static double emptyStatePadding(BuildContext context) => context.rh(40.0);

  static double loadingVerticalPadding(BuildContext context) => context.rh(40.0);

  static double sectionHorizontalPadding(BuildContext context) => context.padding;

  static double gapAfterSectionTitle(BuildContext context) => context.rh(16.0);

  static double gapBetweenFeatures(BuildContext context) => context.rh(12.0);

  static double gapBetweenCards(BuildContext context) => context.rh(16.0);

  static double resultHorizontalPadding(BuildContext context) => context.padding;

  static double resultVerticalPadding(BuildContext context) => context.rh(10.0);

  static double bottomSheetPadding(BuildContext context) => context.rw(20.0);

  static double cardPaddingInner(BuildContext context) => context.rw(16.0);

  static double gapIconText(BuildContext context) => context.rw(6.0);

  static double gapLineVertical(BuildContext context) => context.rh(6.0);

  static double gapInfoLabel(BuildContext context) => context.rh(4.0);

  static double gapChangeBtn(BuildContext context) => context.rh(12.0);

  static double modalPadding(BuildContext context) => context.padding;

  static double searchaddingH(BuildContext context) => context.rw(16.0);

  static double searchaddingV(BuildContext context) => context.rh(8.0);

  static double counterVerticalPadding(BuildContext context) => context.rh(12.0);

  static const int maxTotalPassengers = 9; // Hằng số logic giữ nguyên const

  static double gapInputVertical(BuildContext context) => context.rh(20.0);

  static double gapActionBottom(BuildContext context) => context.rh(32.0);

  static double formInnerPadding(BuildContext context) => context.padding;

  static double gapTabToForm(BuildContext context) => context.rh(16.0);

  static double gapLarge(BuildContext context) => context.rh(24.0);

  static double inputGapV(BuildContext context) => context.rh(12.0);

  static double labelGapV(BuildContext context) => context.rh(4.0);

  static double gapInput(BuildContext context) => context.rh(12.0);

  static double gapLabel(BuildContext context) => context.rh(4.0);

  static double gapSection(BuildContext context) => context.rh(20.0);

  static double gapHeader(BuildContext context) => context.rh(15.0);

  static double gapDivider(BuildContext context) => context.rh(32.0);

  static double gapFooter(BuildContext context) => context.rh(40.0);

  static double gapPassengerGroup(BuildContext context) => context.rh(24.0);

  static double dropdownBuilderHeight(BuildContext context) => context.rh(48.0);

  static double gapTripType(BuildContext context) => context.rw(10.0);

  static double gapFormField(BuildContext context) => context.rh(16.0);

  static double gapSearchButton(BuildContext context) => context.rh(20.0);

  // --- Các giá trị EdgeInsets (Chuyển sang hàm để áp dụng rw/rh) ---

  static EdgeInsets tabPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.rw(16),
    vertical: context.rh(8),
  );

  static EdgeInsets stopPointPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.rw(12),
    vertical: context.rh(8),
  );

  static EdgeInsets stopPointMargin(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(12));

  static EdgeInsets dottedLinePadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(8.0));

  static EdgeInsets tabItemPadding(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(10.0));

  static EdgeInsets featureCardPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(16.0));

  static EdgeInsets resultListPadding(BuildContext context) => EdgeInsets.symmetric(
    vertical: context.rh(10.0),
    horizontal: context.rw(16.0),
  );

  static EdgeInsets selectedTicketPadding(BuildContext context) =>
      EdgeInsets.fromLTRB(context.padding, context.rh(20.0), context.padding, context.rh(10.0));

  static EdgeInsets resultHeaderPadding(BuildContext context) =>
      EdgeInsets.fromLTRB(context.padding, context.rh(20.0), context.padding, context.rh(5.0));

  static EdgeInsets actionButtonPadding(BuildContext context) =>
      EdgeInsets.all(context.padding);
}