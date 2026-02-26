import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../core/utils/responsive_layout.dart';

class FooterContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FooterContactCard({
    super.key,
    required this.icon,
    required this.title,

    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      color: kContactBoxColor, // Màu nền cho thẻ liên hệ

      margin: EdgeInsets.only(bottom: 8),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.wp(3))),

      child: Padding(

        padding: EdgeInsets.all(context.wp(4)),

        child: Row(

          children: [

            Icon(icon, color: kHeaderTextColor, size: context.sp(28)),

            SizedBox(width: context.wp(4)),

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: TextStyle(

                      color: kHeaderTextColor,

                      fontSize: context.sp(16),

                      fontWeight: FontWeight.bold),

                ),

                SizedBox(height: 4),

                Text(

                  subtitle,

                  style: TextStyle(color: kHeaderTextColor, fontSize: context.sp(14)),

                ),

              ],

            ),

          ],

        ),

      ),

    );
  }
}