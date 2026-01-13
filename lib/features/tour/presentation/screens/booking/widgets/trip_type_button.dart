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
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          // Sử dụng các màu sắc từ hằng số của bạn
          backgroundColor: isSelected ? kPrimaryColor : Colors.white,
          side: BorderSide(
            color: isSelected ? kPrimaryColor : kBorderColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            // Nếu chọn thì màu trắng (hoặc kHeaderTextColor), không chọn thì màu đen
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}