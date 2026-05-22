import 'package:flutter/material.dart';

import '../../utils/responsive_layout.dart';

class AppSizes {
  //======================================== Height (Dùng rh) ==========================

  static double searchButton(BuildContext context) => context.rh(50);

  static double destinationListHeight(BuildContext context) => context.rh(200);

  //================================== TourDetail ======================
  static double imageDescription(BuildContext context) => context.rh(250);

  static double tabSection(BuildContext context) => context.rh(50);

  static double reviewItem(BuildContext context) => context.rh(180);

  static double promotionItem(BuildContext context) => context.rh(240);

  static double heightTabAndUnderline(BuildContext context) => context.rh(60);

  // Chuyển const sang hàm để áp dụng rh
  static double heightUnderline(BuildContext context) => context.rh(2.0);

  //================================== Tour Card Item ========================
  static double imageTourCardItem(BuildContext context) => context.rh(200);

  static double errorLoadImageCardItem(BuildContext context) => context.rh(200);

  static double tourCardItemButton(BuildContext context) => context.rh(40);

  //=================================== Review ================================
  static double ratingFilters(BuildContext context) => context.rh(55);

  // Chuyển const sang hàm để áp dụng rh
  static double hIndicator(BuildContext context) => context.rh(8.0);

  //=============================== TravelingBookingScreen =========
  static double hImageLocation(BuildContext context) => context.rh(36);

  //=================================== Width (Dùng rw) =================================

  //=================================== Categories ===========================
  static double imageCategory(BuildContext context) => context.rw(130);

  // Đối với Icon, sử dụng context.icon để đảm bảo tỷ lệ chuẩn
  static double iconAboutUsItem(BuildContext context) => context.icon(40);

  //================================= Tour Category ===========================
  static double wActiveIndicator(BuildContext context) => context.rw(18.0);

  static double wInActiveIndicator(BuildContext context) => context.rw(8.0);

  //=============================== TravelingBookingScreen =========
  static double wTabBorder(BuildContext context) => context.rw(3.0);

  static double wImageLocation(BuildContext context) => context.rw(37);
}