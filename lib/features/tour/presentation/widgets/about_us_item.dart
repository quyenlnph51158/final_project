import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_sizes.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';

class AboutUsItem extends StatelessWidget{
      final IconData icon;
      final String title;
      final  subtitle;
  const AboutUsItem({super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kIconAboutUsItem, size: AppSizes.iconAboutUsItem(context)),
        SizedBox(height: TourLayoutSpacing.iconAndtitleAboutUsItem(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                AppStyles.titleAboutUsItem(context),
              ),
              SizedBox(height: TourLayoutSpacing.titleAndSubtitleAboutUsItem(context)),
              Text(
                subtitle,
                style: AppStyles.subtitleAboutUsItem(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}