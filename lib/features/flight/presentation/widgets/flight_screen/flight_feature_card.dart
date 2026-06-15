import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_layout.dart';

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
      height: context.rh(200),
      child: Card(
        color: kBackgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.sp(16)),
          side:  BorderSide(width: 1.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rw(16.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(context.rw(12.0)),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(context.sp(8)),
                ),
                child: Icon(
                  icon,
                  size: context.icon(40),
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: context.rw(16.0)),
              Text(
                title,
                style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.rw(8.0)),
              Text(
                subtitle,
                style: TextStyle(fontSize: context.sp(14), color: Colors.grey.shade700),
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
