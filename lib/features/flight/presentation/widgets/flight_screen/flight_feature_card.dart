import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';

class FlightFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FlightFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 361,
      height: FlightSize.featureCardHeight(context),
      child: Card(
        color: kBackgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: FlightShape.borderRadiusLarge(context),
          side: BorderSide(color: kBorderColor, width: FlightShape.borderThin),
        ),
        child: Padding(
          padding: FlightLayoutSpacing.featureCardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(FlightLayoutSpacing.iconWrapperPadding),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: FlightShape.borderRadiusSmall(context),
                ),
                child: Icon(
                  icon,
                  size: FlightSize.featureIconSize(context),
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
              Text(
                title,
                style: FlightStyle.featureCardTitle(context),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: FlightLayoutSpacing.gapSmall(context)),
              Text(
                subtitle,
                style: FlightStyle.featureCardSubtitle(context),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
