import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';

import '../../../../core/utils/responsive_layout.dart';

class AboutUsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final subtitle;

  const AboutUsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kIconAboutUsItem, size: context.icon(40)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(16),
                ),
              ),
              SizedBox(height: context.rh(4)),
              Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: context.sp(14))),
            ],
          ),
        ),
      ],
    );
  }
}
