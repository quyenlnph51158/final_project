import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
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
        Icon(icon, color: kIconAboutUsItem, size: AppSizes.iconAboutUsItem),
        AppLayoutSpacing.iconAndtitleAboutUsItem,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                AppStyles.titleAboutUsItem,
              ),
              AppLayoutSpacing.titleAndSubtitleAboutUsItem,
              Text(
                subtitle,
                style: AppStyles.subtitleAboutUsItem,
              ),
            ],
          ),
        ),
      ],
    );
  }
}