import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class AppStyles {
  static TextStyle hintText(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.black54);

  //================================Tour Card Item=======================================
  static TextStyle tourNameCardItem(BuildContext context) =>
      TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold);

  static TextStyle textValue(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: kTextColor);

  static TextStyle tourDescriptionCardItem(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.grey);
  static const durationIcon = TextStyle(color: Colors.grey);

  static TextStyle reviewCountValue(BuildContext context) =>
      TextStyle(color: Colors.black87, fontSize: context.sp(16));

  static const textButton = TextStyle(color: kTextColor);

  static TextStyle priceValue(BuildContext context) => TextStyle(
    fontSize: context.sp(20),
    fontWeight: FontWeight.bold,
    color: kTextColor,
  );

  static final cardItemButton = ElevatedButton.styleFrom(
    backgroundColor: kButtonColor,
    shadowColor: Colors.grey,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 16),
  );

  //=====================================Tour Detail============================
  static TextStyle customerNameReview(BuildContext context) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(16));

  static TextStyle faqTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(24),
    fontWeight: FontWeight.bold,
    color: kTextColor,
  );

  static TextStyle faqQuestion(BuildContext context) => TextStyle(
    fontSize: context.sp(16),
    fontWeight: FontWeight.w400,
    color: const Color(0xFF333333),
    height: 1.4,
  );

  static TextStyle faqAnswer(BuildContext context) =>
      TextStyle(fontSize: context.sp(15), color: Colors.grey[600], height: 1.5);

  //=====================================Review============================
  static const commentReviewItem = TextStyle(fontWeight: FontWeight.bold);

  static TextStyle positiveReviewItem(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.black87);

  static TextStyle promotionTitle(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(20),
    fontWeight: FontWeight.bold,
  );

  static TextStyle promotionDiscountValue(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(32),
    fontWeight: FontWeight.w900,
  );

  static TextStyle categoryName(BuildContext context) =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(20));

  static TextStyle textBasedOn(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.grey);

  static TextStyle averageRatingValue(BuildContext context) =>
      TextStyle(fontSize: context.sp(48), fontWeight: FontWeight.w300);

  static TextStyle averageRatingSuffix(BuildContext context) =>
      TextStyle(fontSize: context.sp(30), color: Colors.grey);

  //========================================AboutUs===============================
  static TextStyle titleAboutUsItem(BuildContext context) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(16));

  static TextStyle subtitleAboutUsItem(BuildContext context) =>
      TextStyle(color: Colors.grey, fontSize: context.sp(14));

  static TextStyle aboutUsVibe(BuildContext context) =>
      GoogleFonts.bonheurRoyale(fontSize: context.sp(40), color: kPrimaryColor);

  static TextStyle aboutUsTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(28),
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );

  static TextStyle labelButtonAboutUs(BuildContext context) =>
      TextStyle(color: Colors.white, fontSize: context.sp(18));

  static TextStyle aboutUsdescription(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.grey);

  static const nameCoFounder = TextStyle(fontWeight: FontWeight.bold);

  static const coFounderRole = TextStyle(color: Colors.grey);

  static TextStyle errorNotFound(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), color: kError);

  //====================================ConsultationForm================================
  static TextStyle labelDepartureDate(BuildContext context) => TextStyle(
    fontSize: context.sp(16),
    fontWeight: FontWeight.w600,
    color: kTextColor,
  );

  static TextStyle labelDeparturePoint(BuildContext context) => TextStyle(
    fontSize: context.sp(16),
    fontWeight: FontWeight.w600,
    color: kTextColor,
  );

  static const viewDetailPolicy = TextStyle(
    color: kIconColorr,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static TextStyle textBookNowAndPayLater(BuildContext context) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(14.5));

  static TextStyle textFlexibleDesc(BuildContext context) => TextStyle(
    fontWeight: FontWeight.normal,
    color: kHintTextColor,
    fontSize: context.sp(14.5),
  );

  static final submitButton = ElevatedButton.styleFrom(
    backgroundColor: kButtonColor,
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.grey, width: 1),
    ),
  );

  static TextStyle textSubmitButton(BuildContext context) => TextStyle(
    fontSize: context.sp(18),
    fontWeight: FontWeight.bold,
    color: kTextColor,
    letterSpacing: 1.5,
  );

  //===========================TravelingBookingScreen================

  static TextStyle titleCategory(BuildContext context) =>
      TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.bold);

  static TextStyle tourSectionVibe(BuildContext context) =>
      GoogleFonts.bonheurRoyale(
        fontSize: context.sp(40),
        color: const Color(0xFF00796B),
      );

  static TextStyle tourSectionTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(28),
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle TravelingBookingHeaderTitle(BuildContext context) =>
      TextStyle(
        color: kHeaderTextColor,
        fontSize: context.sp(24),
        fontWeight: FontWeight.bold,
        height: 1.3,
      );

  static TextStyle promotionSectionVibe(BuildContext context) =>
      GoogleFonts.bonheurRoyale(
        fontSize: context.sp(40),
        color: const Color(0xFF00796B),
      );

  static TextStyle promotionSectionTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(28),
    fontWeight: FontWeight.bold,
    color: kTitleColor,
  );

  static final tripTypeButton = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );

  static const textTab = 12.0;

  static final searchButton = ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static const textSearchButton = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  //=======================================Tour Detail Screen ====================
  static TextStyle hightLightTitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.bold);

  static TextStyle hightLightContent(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), color: Colors.black87, height: 1.5);

  static TextStyle titleReviewSection(BuildContext context) =>
      TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.bold);

  static TextStyle textReadAllReviewSection(BuildContext context) =>
      TextStyle(color: Colors.blue, fontSize: context.sp(16));

  static TextStyle nameCustomerInCard(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold);

  static TextStyle titleScheduleSection(BuildContext context) =>
      TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.bold);

  static TextStyle descriptionScheduleSection(BuildContext context) =>
      TextStyle(fontSize: context.sp(14.5), color: Colors.black87);

  static TextStyle briefInfoScheduleSection(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.black87);

  static TextStyle dayNameScheduleSection(BuildContext context) =>
      TextStyle(fontSize: context.sp(17), fontWeight: FontWeight.bold);

  static TextStyle tourNameInTourDetail(BuildContext context) => TextStyle(
    color: kTextColor,
    fontSize: context.sp(22),
    fontWeight: FontWeight.bold,
    height: 1,
  );

  static TextStyle briefTourDetail(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), color: Colors.black, height: 1.5);

  //================================ShowAirPortAndStationList============

  static TextStyle titleShowList(BuildContext context) =>
      TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold);

  //================================PassengerSelection==================

  static TextStyle titleCounter(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold);

  static TextStyle subtitleCounter(BuildContext context) =>
      TextStyle(fontSize: context.sp(12), color: Colors.grey);

  static TextStyle valueCounter(BuildContext context) =>
      TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold);
}
