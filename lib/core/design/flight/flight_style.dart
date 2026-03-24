import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../../core/constants/colors.dart';

class FlightStyle {
  static TextStyle priceLarge(BuildContext context) => TextStyle(
    fontSize: context.sp(18.0),
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static TextStyle stopPointText(BuildContext context) => TextStyle(
    color: Colors.orange,
    fontSize: context.sp(10),
    fontWeight: FontWeight.bold,
  );

  static TextStyle timeLarge(BuildContext context) =>
      TextStyle(fontSize: context.sp(15.0), fontWeight: FontWeight.bold);

  static TextStyle codeGrey(BuildContext context) =>
      TextStyle(color: Colors.grey, fontSize: context.sp(12.0));

  static TextStyle segmentFlightCode(BuildContext context) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(13.0));

  static TextStyle fareTypeBold(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold);

  static TextStyle featureText(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: kPrimaryColor);

  static TextStyle airportName(BuildContext context) =>
      TextStyle(color: Colors.grey.shade700, fontSize: context.sp(13));

  static TextStyle airportCode(BuildContext context) => TextStyle(
    color: Colors.black,
    fontSize: context.sp(13),
    fontWeight: FontWeight.bold,
  );

  static TextStyle timelineTime(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold);

  static TextStyle timelineDate(BuildContext context) =>
      TextStyle(fontSize: context.sp(10), color: Colors.grey);

  static TextStyle segmentSubText(BuildContext context) =>
      TextStyle(fontSize: context.sp(11), color: Colors.grey.shade700);

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontSize: context.sp(15), // Giữ nguyên logic responsive .sp(15)
  );

  static TextStyle durationSmall(BuildContext context) =>
      TextStyle(color: kTextColor, fontSize: context.sp(10));

  static TextStyle priceMedium(BuildContext context) => TextStyle(
    fontSize: context.sp(16),
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static TextStyle tabActive(BuildContext context) => TextStyle(
    fontSize: context.sp(14),
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static TextStyle tabInactive(BuildContext context) => TextStyle(
    fontSize: context.sp(14),
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade600,
  );

  static TextStyle buttonLarge(BuildContext context) => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: context.sp(20), // Áp dụng responsive cho font size
  );

  static TextStyle cardTitleOverlay(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(28),
    fontWeight: FontWeight.bold,
    shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
  );

  static TextStyle cardSubTitleOverlay(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(16),
    shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
  );

  static TextStyle buttonSearch = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  );
  static final searchFlightButton = ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static TextStyle destinationTitle(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(18),
    fontWeight: FontWeight.bold,
  );

  static TextStyle tabLabel(BuildContext context, {required bool isSelected}) =>
      TextStyle(
        fontSize: context.sp(12),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? kPrimaryColor : Colors.grey,
      );

  static TextStyle featureCardTitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold);

  static TextStyle featureCardSubtitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(14), color: Colors.grey.shade700);

  static TextStyle cardTitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold);

  static TextStyle labelGrey(BuildContext context) =>
      TextStyle(color: Colors.grey, fontSize: context.sp(13));

  static TextStyle priceBold(BuildContext context) => TextStyle(
    fontSize: context.sp(18),
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static TextStyle errorState(BuildContext context) => TextStyle(
    fontSize: context.sp(24),
    // Điều chỉnh lại 24 cho phù hợp đa số màn hình
    fontWeight: FontWeight.bold,
    color: Colors.redAccent,
  );

  static TextStyle sectionTitleBold(BuildContext context) => TextStyle(
    fontSize: context.sp(16),
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle textButtonPrimary(BuildContext context) => TextStyle(
    fontSize: context.sp(14),
    fontWeight: FontWeight.w600,
    color: kPrimaryColor,
  );

  static TextStyle codeHighlight(BuildContext context) => TextStyle(
    color: const Color(0xFF01171B),
    fontSize: context.sp(20),
    fontWeight: FontWeight.w700,
  );

  static TextStyle labelSmallGrey(BuildContext context) => TextStyle(
    color: const Color(0xFF555F65),
    fontSize: context.sp(12),
    fontWeight: FontWeight.w400,
  );

  static TextStyle infoLabel(BuildContext context) => TextStyle(
    color: const Color(0xFF01171B),
    fontSize: context.sp(12),
    fontWeight: FontWeight.w600,
  );

  static TextStyle infoValue(BuildContext context) => TextStyle(
    color: const Color(0xFF01171B),
    fontSize: context.sp(16),
    fontWeight: FontWeight.w600,
  );

  static TextStyle linkButton(BuildContext context) => TextStyle(
    color: kPrimaryColor,
    fontSize: context.sp(14),
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );

  static TextStyle modalTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(18),
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle airportItemTitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(15), fontWeight: FontWeight.w500);

  static TextStyle counterLabel(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold);

  static TextStyle counterSubtitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(12), color: Colors.grey);

  static TextStyle counterValue(BuildContext context) =>
      TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold);

  static TextStyle labelField(BuildContext context) =>
      TextStyle(fontSize: context.sp(16), color: Colors.grey.shade700);

  static TextStyle fieldValue(BuildContext context) => TextStyle(
    fontSize: context.sp(15),
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static TextStyle inputFieldText(BuildContext context) => TextStyle(    fontSize: context.sp(16),
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );

  static TextStyle inputLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(14),
    color: Colors.grey.shade700,
  );
  static TextStyle sectionHeader(BuildContext context) => TextStyle(
    color: kTextColor,
    fontSize: context.sp(20),
    fontWeight: FontWeight.w700,
  );

  static TextStyle infoBoxDescription(BuildContext context) => TextStyle(
    fontSize: context.sp(14),
    color: const Color(0xFF555F65),
    height: 1.4,
  );

  static TextStyle passengerGroupLabel(BuildContext context) => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: context.sp(15),
    color: kPrimaryColor,
  );

  static TextStyle infoBoxTitle(BuildContext context) => TextStyle(
      fontSize: context.sp(16),
      fontWeight: FontWeight.bold
  );

  static TextStyle hintStyle(BuildContext context) => TextStyle(
    color: const Color(0xFFA9B2B7),
    fontSize: context.sp(14),
  );

  static TextStyle countryFlag(BuildContext context) => TextStyle(fontSize: context.sp(18));
  static TextStyle countryName(BuildContext context) => TextStyle(fontSize: context.sp(14));
  static TextStyle countryDialCode(BuildContext context) => TextStyle(fontSize: context.sp(13), color: Colors.grey.shade700);
  static TextStyle frequentFlyerTitle(BuildContext context) => TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(15));
}
