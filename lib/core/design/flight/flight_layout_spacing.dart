import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart'; // Import extension của bạn

class FlightLayoutSpacing {
  // Thay vì dùng số cứng 10.0, dùng % chiều cao màn hình
  static double cardMarginV(BuildContext context) => context.hp(1);

  static double paddingAll(BuildContext context) => context.wp(4.0);

  static double gapMedium(BuildContext context) => context.wp(4.0);

  static double gapSmall(BuildContext context) => context.wp(2.0);
  static const EdgeInsets tabPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  static double timelineIndent(BuildContext context) => context.wp(15.0);

  static double timelineGap(BuildContext context) => 12;
  static const double segmentGap = 12.0;
  static const double featureBottomPadding = 6.0;
  static double gapIcon = 8.0;
  static double featurePaddingBottom = 6.0;
  static const EdgeInsets stopPointPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets stopPointMargin = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets dottedLinePadding = EdgeInsets.symmetric(
    horizontal: 8.0,
  );
  static double tabGap = 24.0; // Khoảng cách giữa các tab
  static double timelineTimeGap = 24; // (timelineGap * 2)
  static double overlayPadding(BuildContext context) =>
      context.wp(5.0); // Thay cho 20.0
  static double destinationPadding = 4.0;
  static double destinationContentOffset = 10.0;
  static const EdgeInsets tabItemPadding = EdgeInsets.symmetric(vertical: 10.0);
  static double iconWrapperPadding = 12.0;
  static const EdgeInsets featureCardPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );

  static double cardPadding(BuildContext context) => context.wp(3.0);
  static const double iconTextGap = 4.0;
  static const double headerHorizontalPadding = 16.0;
  static const double gridHorizontalPadding = 16.0;
  static const double gridGap = 12.0;

  static double gapInputHorizontal(BuildContext context) => context.wp(2.0);
  static const double screenHorizontalPadding = 16.0;

  static double emptyStatePadding(BuildContext context) => context.hp(5.0);

  static double loadingVerticalPadding(BuildContext context) => context.hp(5.0);

  static double sectionHorizontalPadding(BuildContext context) =>
      context.wp(4.0);

  static double gapAfterSectionTitle(BuildContext context) => context.hp(2.0);
  static const double gapBetweenFeatures = 12.0;
  static const double gapBetweenCards = 16.0;
  static const double resultHorizontalPadding = 16.0;
  static const double resultVerticalPadding = 10.0;
  static const EdgeInsets resultListPadding = EdgeInsets.symmetric(
    vertical: resultVerticalPadding,
    horizontal: resultHorizontalPadding,
  );

  static EdgeInsets selectedTicketPadding(BuildContext context) =>
      EdgeInsets.fromLTRB(16.0, context.hp(2.5), 16.0, 10.0);

  static EdgeInsets resultHeaderPadding(BuildContext context) =>
      EdgeInsets.fromLTRB(16.0, context.hp(2.5), 16.0, 5.0);
  static const EdgeInsets actionButtonPadding = EdgeInsets.all(16.0);
  static const double bottomSheetPadding = 20.0;
  static const double cardPaddingInner = 16.0;
  static const double gapIconText = 6.0;
  static const double gapLineVertical = 6.0;
  static const double gapInfoLabel = 4.0;
  static const double gapChangeBtn = 12.0;
  static const double modalPadding = 12.0;
  static const double searchPaddingH = 16.0;
  static const double searchPaddingV = 8.0;
  static const double counterVerticalPadding = 12.0;
  static const int maxTotalPassengers = 9;
  static double gapInputVertical(BuildContext context) => context.hp(2.5);
  static double gapActionBottom(BuildContext context) => context.hp(4.0);
  static double formInnerPadding(BuildContext context) => context.wp(4.0);
  static double gapTabToForm(BuildContext context) => context.hp(2.0);
  static double gapLarge(BuildContext context) => context.hp(3.0);

  static const double inputGapV = 12.0;
  static const double labelGapV = 4.0;

  // Các khoảng cách dọc (Gaps)
  static double gapInput(BuildContext context) => 12.0;
  static double gapLabel(BuildContext context) => 4.0;
  static double gapSection(BuildContext context) => 20.0;
  static double gapHeader(BuildContext context) => 15.0;
  static double gapDivider(BuildContext context) => 32.0;
  static double gapFooter(BuildContext context) => 40.0;
  static const double gapPassengerGroup = 24.0;
  static const double dropdownBuilderHeight = 20.0;
  static const double gapTripType = 10.0;
  static const double gapFormField = 16.0;
  static double gapSearchButton(BuildContext context) => context.hp(2.5); // Thay cho 20.0

}
