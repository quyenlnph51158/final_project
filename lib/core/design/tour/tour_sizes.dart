import 'package:flutter/material.dart';

import '../../utils/responsive_layout.dart';

class AppSizes {

  //========================================Height==========================
  static double searchButton(BuildContext context) => context.hp(6);
  static double destinationListHeight(BuildContext context) => context.hp(25);

  //==================================TourDetail======================
  static double imageDescription(BuildContext context) => context.hp(30);
  static double tabSection(BuildContext context) => context.hp(10);
  static double reviewItem(BuildContext context) => context.hp(22);
  static double promotionItem(BuildContext context) => context.hp(30);
  static double heightTabAndUnderline(BuildContext context) => context.hp(12);

  static const heightUnderline = 2.0;

  //==================================Tour Card Item ========================
  static double imageTourCardItem(BuildContext context) => context.hp(24);
  static double errorLoadImageCardItem(BuildContext context) => context.hp(24);
  static double tourCardItemButton(BuildContext context) => context.hp(5);

  //===================================Review================================
  static double ratingFilters(BuildContext context) => context.hp(7);

  //=================================Tour Category===========================
  static const hIndicator = 8.0;

  //===============================TravelingBookingScreen=========
  static double hImageLocation(BuildContext context) => context.hp(4.5);

  //===================================width=================================
  //===================================Categories===========================
  static double imageCategory(BuildContext context) => context.wp(35);
  static double iconAboutUsItem(BuildContext context) => context.sp(40);

  //=================================Tour Category===========================
  static const wActiveIndicator = 18.0;
  static const wInActiveIndicator = 8.0;

  //===============================TravelingBookingScreen=========
  static const wTabBorder = 3.0;
  static double wImageLocation(BuildContext context) => context.wp(10);
}