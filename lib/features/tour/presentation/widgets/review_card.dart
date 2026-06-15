import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_layout.dart';

class ReviewCard extends StatelessWidget{
  final Widget child;
  final double width;
  const ReviewCard({super.key, required this.child, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: context.rw(12)),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: kBorderColor),
      ),
      child: child,
    );
  }
}