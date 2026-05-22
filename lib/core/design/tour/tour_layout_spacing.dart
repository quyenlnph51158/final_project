import 'package:flutter/material.dart';
import '../../utils/responsive_layout.dart';

class TourLayoutSpacing {
  static double valueInField(BuildContext context) => context.rw(12);
  static double fieldAndButton(BuildContext context) => context.rh(24);

  //===================================SizedBox (Dọc dùng rh, Ngang dùng rw)=========================
  static double tourNameAndTourDescription(BuildContext context) => context.rh(8);
  static double tourDescriptionAndDurationStar(BuildContext context) => context.rh(12);
  static double averageRatingAndStar(BuildContext context) => context.rh(4);
  static double tabAndForm(BuildContext context) => context.rh(16);

  //===========================TourCardItem==================
  static double durationIconAndValue(BuildContext context) => context.rh(4);

  //==================AboutUsSection======================
  static double labelandcontent(BuildContext context) => context.rh(16);
  static double itemAndButtonAboutUs(BuildContext context) => context.rh(32);
  static double buttonAboutUsAndCoFounder(BuildContext context) => context.rh(16);
  static double imageAndIformation(BuildContext context) => context.rh(8);
  static double iconAndtitleAboutUsItem(BuildContext context) => context.rh(16);
  static double titleAndSubtitleAboutUsItem(BuildContext context) => context.rh(4);

  //==================LoadImageListAutoScroll=================
  static double imageAndLengthLoad(BuildContext context) => context.rh(8);

  //==================CustomerReview==========================
  static double starAndComment(BuildContext context) => context.rh(8);
  static double customerNameAndStarIcon(BuildContext context) => context.rh(4);
  static double starIconAndComment(BuildContext context) => context.rh(8);
  static double averageRatingAndInfo(BuildContext context) => context.rw(12);

  //==================TourDetail==============================
  static double dayNameAndBriefInfo(BuildContext context) => context.rh(4);
  static double iconAndContent(BuildContext context) => context.rh(12);
  static double headerNamePosition(BuildContext context) => context.rh(8);
  static double titleReviewAndContent(BuildContext context) => context.rh(8);
  static double iconStarAndInfoReview(BuildContext context) => context.rh(4);
  static double reviewInfoAndReviewItem(BuildContext context) => context.rh(24);
  static double customAppBarAndTourName(BuildContext context) => context.rh(24);
  static double textTabAndUnderline(BuildContext context) => context.rh(8);

  //===================Pagination=============================
  static double iconpage(BuildContext context) => context.rw(12);
  static double itemAndPagination(BuildContext context) => context.rh(16);

  //===================Promotion-Tour Screen==================
  static double titleAndDiscountValue(BuildContext context) => context.rh(8);
  static double titleAndPromotionCard(BuildContext context) => context.rh(16);

  //========================ConsultationForm=====================
  static double field(BuildContext context) => context.rh(16);
  static double departureInfoAndField(BuildContext context) => context.rh(24);
  static double fieldAndPolicyOrButton(BuildContext context) => context.rh(32);
  static double iconAndValue(BuildContext context) => context.rw(8);
  static double departureDateAndDeparturePoint(BuildContext context) => context.rh(24);
  static double IconCancellationAndText(BuildContext context) => context.rh(8);
  static double textBookNowAndFlexibleText(BuildContext context) => context.rh(4);

  //====================Show Airport Or Station List ============
  static double handleAndTitle(BuildContext context) => context.rh(8);

  //==========================EdgeInsets======================
  //==========================TravelingBookingScreen==========

  static EdgeInsets titleHeader(BuildContext context) => EdgeInsets.only(
    left: context.padding, // rw(12) hoặc rw(16) chuẩn app
    top: context.rh(20),
    right: context.padding,
  );

  //==========================Tour Card Item =================
  static EdgeInsets tourCardItemContent(BuildContext context) =>
      EdgeInsets.all(context.rw(16));

  static EdgeInsets bottomTourCardItem(BuildContext context) => EdgeInsets.only(
    bottom: context.rh(24),
    left: context.padding,
    right: context.padding,
  );

  static EdgeInsets contentInReviewCard(BuildContext context) =>
      EdgeInsets.all(context.rw(12));

  //==========================Review Tour Screen===============
  static EdgeInsets marginCardItem(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.padding,
    vertical: context.rh(8),
  );

  static EdgeInsets paddingCardItem(BuildContext context) =>
      EdgeInsets.all(context.rw(16));

  static EdgeInsets marginReviewCard(BuildContext context) =>
      EdgeInsets.only(right: context.rw(12));

  static EdgeInsets paddingRatingFilter(BuildContext context) => EdgeInsets.symmetric(
    vertical: context.rh(10),
  );

  static EdgeInsets paddingRatingFilterState(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingRatingFilterItem(BuildContext context) =>
      EdgeInsets.only(right: context.rw(8));

  static EdgeInsets paddingPromotionCardItem(BuildContext context) =>
      EdgeInsets.all(context.rw(16));

  static EdgeInsets paddingSummaryHeaderTour(BuildContext context) =>
      EdgeInsets.all(context.rw(16));

  //==========================Categories=========================
  static EdgeInsets marginDestinationCard(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(4));

  static EdgeInsets categoryNameAndImage(BuildContext context) =>
      EdgeInsets.only(top: context.rh(4));

  static EdgeInsets paddingDestinationSection(BuildContext context) =>
      EdgeInsets.only(
        left: context.rw(32),
        right: context.rw(32),
        top: context.rh(24),
        bottom: context.rh(8),
      );

  static EdgeInsets paddingCategoryCard(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(12));

  //==========================aboutUs============================
  static EdgeInsets labelButtonAboutUs(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(16));

  static EdgeInsets aboutUsSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets aboutUsDescription(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(8));

  //==========================Featured Tour Section==============
  static EdgeInsets paddingFeaturedTourSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingTourCardError(BuildContext context) =>
      EdgeInsets.all(context.rw(24));

  static EdgeInsets paddingTourCard(BuildContext context) =>
      EdgeInsets.only(bottom: context.rh(16));

  static EdgeInsets paddingAppbarAndTitle(BuildContext context) =>
      EdgeInsets.only(
        left: context.padding,
        top: context.rh(20),
        right: context.padding,
      );

  //======================Promotion Section=======================
  static EdgeInsets paddingPromotionSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingBottomPromotionCard(BuildContext context) =>
      EdgeInsets.only(bottom: context.rh(24));

  //========================Tour Detail Screen===================
  static EdgeInsets iconHighLight(BuildContext context) => EdgeInsets.only(
    top: context.rh(2),
    right: context.rw(10),
  );

  static EdgeInsets iconCancellation(BuildContext context) =>
      EdgeInsets.only(top: context.rh(2));

  static EdgeInsets paddingHighLight(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingImageCarousel(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(10));

  static EdgeInsets reviewTourDetailSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets scheduleTourDetailSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingExpadedDescriptionSchedule(BuildContext context) =>
      EdgeInsets.fromLTRB(
        context.rw(16),
        context.rh(8),
        context.rw(16),
        context.rw(16),
      );

  static EdgeInsets paddingFaqSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingContentScheduleItem(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.rw(16),
        vertical: context.rh(14),
      );

  static EdgeInsets paddingTourDetailName(BuildContext context) => EdgeInsets.only(
    left: context.padding,
    right: context.padding,
  );

  static EdgeInsets paddingBriefTourDetail(BuildContext context) => EdgeInsets.only(
    left: context.padding,
    top: context.rh(30),
    right: context.padding,
    bottom: context.rh(20),
  );

  static EdgeInsets paddingConsultationSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingConsultationForm(BuildContext context) =>
      EdgeInsets.all(context.rw(16));

  static EdgeInsets paddingDepartureDate(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.rw(12),
        vertical: context.rh(8),
      );

  static EdgeInsets paddingDeparturePoint(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.rw(12),
        vertical: context.rh(8),
      );

  static EdgeInsets paddingTabSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(12));

  static EdgeInsets paddingTabItem(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(16));

  static EdgeInsets paddingTripTypeButton(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(12));

  static EdgeInsets paddingtabform(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(10));

  static EdgeInsets paddingContentInField(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.rw(15),
        vertical: context.rh(15),
      );

  static EdgeInsets paddingFaqsTitleAndItem(BuildContext context) =>
      EdgeInsets.only(bottom: context.rh(16));

  static EdgeInsets paddingFaqItem(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(16));

  //========================Indicator============================
  static EdgeInsets marginIndicator(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.rw(4));

  //========================ShowAirportAndStationList============
  static EdgeInsets paddingHandleAndTitle(BuildContext context) =>
      EdgeInsets.all(context.rw(12));

  static EdgeInsets paddingSearchBox(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.padding,
    vertical: context.rh(8),
  );

  static EdgeInsets paddingContentSearchBox(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(15));

  //=======================SelectionPassenger===========================
  static EdgeInsets paddingContentSelectionPassenger(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.padding);

  static EdgeInsets paddingHeaderSelectionPassenger(BuildContext context) =>
      EdgeInsets.all(context.rw(16));

  static EdgeInsets paddingContentCounterPassenger(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.rh(16));

  static EdgeInsets paddingConfirmPassengerButton(BuildContext context) =>
      EdgeInsets.fromLTRB(
        context.padding,
        context.rh(10),
        context.padding,
        context.rh(35), // Safe Area padding bottom cho máy thật
      );
}
