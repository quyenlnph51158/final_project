import 'package:final_project/core/constants/image_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/tour/presentation/screens/travel_booking_screen.dart';

class CustomAppBar extends StatelessWidget {
  final Color?  backgroundColor;
  final String? image;
  const CustomAppBar({
    super.key,
    this.backgroundColor,
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const TravelBookingScreen(),
                ),
              );
            },
            child: SvgPicture.network(
              image==null
                  ? ImageLink.logoDefaultAppHeader
                  : image.toString(),
              height: 50,
              width: 50,
            ),
          ),

          // Nút Menu (Builder để truy cập Scaffold)
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: backgroundColor ?? Colors.white, size: 30),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}