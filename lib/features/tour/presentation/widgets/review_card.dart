import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget{
  final Widget child;
  final double width;
  const ReviewCard({super.key, required this.child, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: TourLayoutSpacing.marginReviewCard(context),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: AppShape.reviewCard,
        border: Border.all(color: kBorderColor),
      ),
      child: child,
    );
  }
}