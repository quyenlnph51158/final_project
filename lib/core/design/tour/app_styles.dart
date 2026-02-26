import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class AppStyles {
  static const hintText = TextStyle(fontSize: 14, color: Colors.black54);
  //================================Tour Card Item=======================================
  static const tourNameCardItem =TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const textValue = TextStyle(fontSize: 14, color: kTextColor);
  static const tourDescriptionCardItem = TextStyle(fontSize: 14, color: Colors.grey);

  static const durationIcon = TextStyle(color: Colors.grey);

  static const reviewCountValue = TextStyle(color: Colors.black87, fontSize: 16);

  static const textButton = TextStyle(color: kTextColor);

  static const priceValue = TextStyle(
    fontSize: 20,
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
  static const customerNameReview = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  //=====================================Review============================
  static const  commentReviewItem = TextStyle(fontWeight: FontWeight.bold);
  static const positiveReviewItem = TextStyle(fontSize: 14, color: Colors.black87);
  static const promotionTitle= TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const promotionDiscountValue =TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.w900,
  );
  static const categoryName = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 20,
  );
  static const textBasedOn = TextStyle(fontSize: 14, color: Colors.grey);
  static const averageRatingValue = TextStyle(fontSize: 48, fontWeight: FontWeight.w300);
  static const averageRatingSuffix = TextStyle(fontSize: 30, color: Colors.grey);

  //========================================AboutUs===============================
  static const titleAboutUsItem = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  static const subtitleAboutUsItem = TextStyle(color: Colors.grey, fontSize: 14);
  static final aboutUsVibe = GoogleFonts.bonheurRoyale(
    fontSize: 24,
    color: kPrimaryColor,
  );
  static const aboutUsTitle =TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );
  static const labelButtonAboutUs = TextStyle(color: Colors.white, fontSize: 18);
  static const aboutUsdescription = TextStyle(fontSize: 14, color: Colors.grey);
  static const nameCoFounder = TextStyle(fontWeight: FontWeight.bold);
  static const coFounderRole = TextStyle(color: Colors.grey);
  static const errorNotFound = TextStyle(fontSize: 16, color: kError);
  //====================================ConsultationForm================================
  static const labelDepartureDate = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: kTextColor);
  static const labelDeparturePoint = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: kTextColor);
  static const viewDetailPolicy =TextStyle(
  color: kIconColorr, // Màu xanh đậm
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.underline,
  );
  static const textBookNowAndPayLater = TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5);
  static const textFlexibleDesc = TextStyle(
      fontWeight: FontWeight.normal,
      color: kHintTextColor,
      fontSize: 14.5);
  static final submitButton = ElevatedButton.styleFrom(
    backgroundColor: kButtonColor,
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(
        color: Colors.grey, // màu viền
        width: 1,           // độ dày
      ),
    ),
  );
  static const textSubmitButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: kTextColor,
    letterSpacing: 1.5,
  );
  //===========================TravelingBookingScreen================
  static const titleHeader = TextStyle(
      color: kHeaderTextColor,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3);
  static const titleCategory = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static final tourSectionVibe = GoogleFonts.bonheurRoyale(
  fontSize: 50,
  color: Color(0xFF00796B),
  );
  static const tourSectionTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  static const TravelingBookingHeaderTitle =TextStyle(
    color: kHeaderTextColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  static final promotionSectionVibe = GoogleFonts.bonheurRoyale(
      fontSize: 50,
      color: Color(0xFF00796B)
  );
  static final promotionSectionTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: kTitleColor,
  );
  static final tripTypeButton = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );
  static const textTab = 12.0;
  static final searchButton = ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape:
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
  static const textSearchButton = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  //=======================================Tour Detail Screen ====================
  static const hightLightTitle =TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const hightLightContent = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.5,
  );
  static const titleReviewSection = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const textReadAllReviewSection = TextStyle(color: Colors.blue, fontSize: 16);
  static const nameCustomerInCard = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold);
  static const titleScheduleSection = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const descriptionScheduleSection = TextStyle(
      fontSize: 14.5,
      color: Colors.black87,
  );
  static const briefInfoScheduleSection = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );
  static const dayNameScheduleSection =TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );
  static const tourNameInTourDetail = TextStyle(
      color: kTextColor,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      height: 1);
  static const briefTourDetail =TextStyle(
    fontSize: 16,
    color: Colors.black,
    height: 1.5,
  );
  //================================ShowAirPortAndStationList============
  static const titleShowList = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold);
  //================================PassengerSelection==================
  static const titleCounter = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const subtitleCounter = TextStyle(fontSize: 12, color: Colors.grey);
  static const valueCounter = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

}