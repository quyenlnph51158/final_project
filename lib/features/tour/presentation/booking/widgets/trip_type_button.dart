import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
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
    // Luôn sử dụng Expanded vì trên Mobile các nút loại hình tour thường chia đều theo hàng ngang
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? kPrimaryColor : kBackgroundColor,
          side: BorderSide(
            color: isSelected ? kPrimaryColor : kBorderColor,
            width: 1.5,
          ),
          // Sử dụng độ bo góc từ extension (context.radius)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius),
          ),
          // Sử dụng padding đã định nghĩa theo sp()
          padding: TourLayoutSpacing.paddingTripTypeButton(context),
          elevation: 0,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            // Nếu chọn thì chữ đậm và màu sáng, không chọn thì chữ thường
            color: isSelected ? Colors.white : kTextColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            // Font chữ co giãn theo màn hình bằng context.sp
            fontSize: context.sp(14),
          ),
        ),
      ),
    );
  }
}