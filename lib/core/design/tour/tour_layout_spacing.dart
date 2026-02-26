import 'package:final_project/core/design/shared/app_spacing.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive_layout.dart';

class TourLayoutSpacing {

  static const valueInField = AppSpacing.w12;
  static const fieldAndButton = AppSpacing.h24;
  //===================================SizedBox=========================
  static const tourNameAndTourDescription = AppSpacing.h8;
  static const tourDescriptionAndDurationStar = AppSpacing.h12;
  static const averageRatingAndStar = AppSpacing.h4;
  static const tabAndForm = AppSpacing.h16;

  //===========================TourCardItem==================
  static const durationIconAndValue = AppSpacing.h4;

  //==================AboutUsSection======================
  static const labelandcontent= AppSpacing.h16;
  static const itemAndButtonAboutUs= AppSpacing.h32;
  static const buttonAboutUsAndCoFounder = AppSpacing.h16;
  static const imageAndIformation = AppSpacing.h8;
  static const iconAndtitleAboutUsItem= AppSpacing.h16;
  static const titleAndSubtitleAboutUsItem = AppSpacing.h4;

  //==================LoadImageListAutoScroll=================
  static const imageAndLengthLoad = AppSpacing.h8;

  //==================CustomerReview==========================
  static const starAndComment = AppSpacing.h8;
  static const customerNameAndStarIcon = AppSpacing.h4;
  static const starIconAndComment = AppSpacing.h8;
  static const averageRatingAndInfo = AppSpacing.w12;

  //==================TourDetail==============================
  static const dayNameAndBriefInfo = AppSpacing.h4;
  static const iconAndContent = AppSpacing.h12;
  static const headerNamePosition= AppSpacing.h8;
  static const titleReviewAndContent = AppSpacing.h8;
  static const iconStarAndInfoReview = AppSpacing.h4;
  static const reviewInfoAndReviewItem = AppSpacing.h24;
  static const customAppBarAndTourName = AppSpacing.h24;
  static const textTabAndUnderline = AppSpacing.h8;

  //===================Pagination=============================
  static const iconpage = AppSpacing.w12;
  static const itemAndPagination = AppSpacing.h16;

  //===================Promotion-Tour Screen==================
  static const titleAndDiscountValue = AppSpacing.h8;
  static const titleAndPromotionCard = AppSpacing.h16;

  //========================ConsultationForm=====================
  static const field = AppSpacing.h16;
  static const departureInfoAndField = AppSpacing.h24;
  static const fieldAndPolicyOrButton = AppSpacing.h32;
  static const iconAndValue = AppSpacing.w8;
  static const departureDateAndDeparturePoint = AppSpacing.h24;
  static const IconCancellationAndText= AppSpacing.h8;
  static const textBookNowAndFlexibleText = AppSpacing.h4;

  //====================Show Airport Or Station List ============
  static const handleAndTitle = AppSpacing.h8;

  //==========================EdgeInsets======================
  //==========================TravelingBookingScreen==========

  static EdgeInsets titleHeader(BuildContext context) =>
      EdgeInsets.only(
        left: context.sp(20),
        top: context.sp(20),
        right: context.sp(20),
      );

  //==========================Tour Card Item =================
  static EdgeInsets tourCardItemContent(BuildContext context) =>
      EdgeInsets.all(context.sp(16));

  static EdgeInsets bottomTourCardItem(BuildContext context) =>
      EdgeInsets.only(
        bottom: context.sp(24),
        left: context.sp(16),
        right: context.sp(16),
      );

  static EdgeInsets contentInReviewCard(BuildContext context) =>
      EdgeInsets.all(context.sp(12));

  //==========================Review Tour Screen===============
  static EdgeInsets marginCardItem(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.sp(16),
        vertical: context.sp(8),
      );

  static EdgeInsets paddingCardItem(BuildContext context) =>
      EdgeInsets.all(context.sp(16));

  static EdgeInsets marginReviewCard(BuildContext context) =>
      EdgeInsets.only(right: context.sp(12));

  static EdgeInsets paddingRatingFilter(BuildContext context) =>
      EdgeInsets.only(
        top: context.sp(10),
        bottom: context.sp(10),
      );

  static EdgeInsets paddingRatingFilterState(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(16));

  static EdgeInsets paddingRatingFilterItem(BuildContext context) =>
      EdgeInsets.only(right: context.sp(8));

  static EdgeInsets paddingPromotionCardItem(BuildContext context) =>
      EdgeInsets.all(context.sp(16));

  static EdgeInsets paddingSummaryHeaderTour(BuildContext context) =>
      EdgeInsets.all(context.sp(16));

  //==========================Categories=========================
  static EdgeInsets marginDestinationCard(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(4));

  static EdgeInsets categoryNameAndImage(BuildContext context) =>
      EdgeInsets.only(top: context.sp(4));

  static EdgeInsets paddingDestinationSection(BuildContext context) =>
      EdgeInsets.only(
        left: context.sp(32),
        right: context.sp(32),
        top: context.sp(24),
        bottom: context.sp(8),
      );

  static EdgeInsets paddingCategoryCard(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(12));

  //==========================aboutUs============================
  static EdgeInsets labelButtonAboutUs(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.sp(16));

  static EdgeInsets aboutUsSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(16));

  static EdgeInsets aboutUsDescription(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(8));

  //==========================Featured Tour Section==============
  static EdgeInsets paddingFeaturedTourSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.wp(4));

  static EdgeInsets paddingTourCardError(BuildContext context) =>
      EdgeInsets.all(context.sp(24));

  static EdgeInsets paddingTourCard(BuildContext context) =>
      EdgeInsets.only(bottom: context.sp(16));

  static EdgeInsets paddingAppbarAndTitle(BuildContext context) =>
      EdgeInsets.only(
        left: context.sp(20),
        top: context.sp(20),
        right: context.sp(20),
      );

  //======================Promotion Section=======================
  static EdgeInsets paddingPromotionSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.wp(4));

  static EdgeInsets paddingBottomPromotionCard(BuildContext context) =>
      EdgeInsets.only(bottom: context.sp(24));

  //========================Tour Detail Screen===================
  static EdgeInsets iconHighLight(BuildContext context) =>
      EdgeInsets.only(
        top: context.sp(2),
        right: context.sp(10),
      );

  static EdgeInsets iconCancellation(BuildContext context) =>
      EdgeInsets.only(top: context.sp(2));

  static EdgeInsets paddingHighLight(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.wp(4));

  static EdgeInsets paddingImageCarousel(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(10));

  static EdgeInsets reviewTourDetailSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(16));

  static EdgeInsets scheduleTourDetailSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(16));

  static EdgeInsets paddingExpadedDescriptionSchedule(BuildContext context) =>
      EdgeInsets.fromLTRB(
        context.sp(16),
        context.sp(8),
        context.sp(16),
        context.sp(16),
      );

  static EdgeInsets paddingFaqSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.wp(4));

  static EdgeInsets paddingContentScheduleItem(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.sp(16),
        vertical: context.sp(14),
      );

  static EdgeInsets paddingTourDetailName(BuildContext context) =>
      EdgeInsets.only(
        left: context.sp(20),
        right: context.sp(20),
      );

  static EdgeInsets paddingBriefTourDetail(BuildContext context) =>
      EdgeInsets.only(
        left: context.sp(20),
        top: context.sp(30),
        right: context.sp(20),
        bottom: context.sp(20),
      );

  static EdgeInsets paddingConsultationSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.wp(4));

  static EdgeInsets paddingConsultationForm(BuildContext context) =>
      EdgeInsets.all(context.sp(16));

  static EdgeInsets paddingDepartureDate(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.sp(12),
        vertical: context.sp(8),
      );

  static EdgeInsets paddingDeparturePoint(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.sp(12),
        vertical: context.sp(8),
      );

  static EdgeInsets paddingTabSection(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(12));

  static EdgeInsets paddingTabItem(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(16));

  static EdgeInsets paddingTripTypeButton(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.sp(12));

  static EdgeInsets paddingtabform(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.sp(10));

  static EdgeInsets paddingContentInField(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.sp(15),
        vertical: context.sp(15),
      );

  static EdgeInsets paddingFaqsTitleAndItem(BuildContext context) =>
      EdgeInsets.only(bottom: context.sp(16));

  static EdgeInsets paddingFaqItem(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.sp(16));

  //========================Indicator============================
  static EdgeInsets marginIndicator(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(4));

  //========================ShowAirportAndStationList============
  static EdgeInsets paddingHandleAndTitle(BuildContext context) =>
      EdgeInsets.all(context.sp(12));

  static EdgeInsets paddingSearchBox(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.sp(16),
        vertical: context.sp(8),
      );

  static EdgeInsets paddingContentSearchBox(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.sp(15));

  //=======================SelectionPassenger===========================
  static EdgeInsets paddingContentSelectionPassenger(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.sp(16));

  static EdgeInsets paddingHeaderSelectionPassenger(BuildContext context) =>
      EdgeInsets.all(context.sp(16));

  static EdgeInsets paddingContentCounterPassenger(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.sp(16));

  static EdgeInsets paddingConfirmPassengerButton(BuildContext context) =>
      EdgeInsets.symmetric(
        vertical: context.sp(35),
        horizontal: context.sp(16),
      );
}