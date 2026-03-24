import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';

class TripTypeButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const TripTypeButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // Sử dụng các màu sắc từ hằng số của bạn
        backgroundColor: isSelected ? kPrimaryColor : kBackgroundColor,
        side: BorderSide(
          color: isSelected ? kPrimaryColor : kBorderColor,
          width: 1.5,
        ),
        shape: AppStyles.tripTypeButton,
        padding: TourLayoutSpacing.paddingTripTypeButton(context),
      ),
      child: Text(
        text,
        style: TextStyle(
          // Nếu chọn thì màu trắng (hoặc kHeaderTextColor), không chọn thì màu đen
          color: isSelected ? kHeaderTextColor : kTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    /// MOBILE → full width
    if (context.isMobile==true) {
    return Expanded(child: button);
    }

    /// TABLET / DESKTOP → fixed width
    return SizedBox(
    width: 180,
    child: button,
    );
  }
}