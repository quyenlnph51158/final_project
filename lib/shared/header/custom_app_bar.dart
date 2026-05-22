import 'package:final_project/core/constants/image_link.dart';
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/responsive_layout.dart';
import '../../features/tour/presentation/screens/travel_booking_screen.dart';
import '../../features/train/presentation/controller/train_controller.dart';

class CustomAppBar extends StatelessWidget {
  final Color? backgroundColor;
  final String? image;

  const CustomAppBar({super.key, this.backgroundColor, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Sử dụng rw cho padding ngang đồng bộ với lề thiết kế
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(
          8,
        ), // Dùng rh thay vì h(1) để kiểm soát pixel tốt hơn
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO SECTION
          InkWell(
            onTap: () {
              context.read<TravelBookingController>().resetToInitial();
              context.read<FlightController>().resetToInitial();
              context.read<TrainController>().resetToInitial();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const TravelBookingScreen()),
              );
            },
            child: SvgPicture.network(
              image ?? ImageLink.logoDefaultAppHeader,
              // Sử dụng icon() để scale logo mượt mà theo mật độ điểm ảnh
              height: context.icon(50),
              width: context.icon(50),
              fit: BoxFit.contain,
              placeholderBuilder: (context) =>
                  SizedBox(height: context.icon(40), width: context.icon(40)),
            ),
          ),

          // MENU BUTTON SECTION
          Builder(
            builder: (innerContext) => IconButton(
              // Scale icon menu theo kích thước icon chuẩn
              icon: Icon(
                Icons.menu,
                color: backgroundColor ?? Colors.white,
                size: context.icon(28),
              ),
              onPressed: () => Scaffold.of(innerContext).openEndDrawer(),

              // Tăng diện tích vùng bấm (Touch Target) đạt chuẩn 44-48dp
              // nhưng không làm thay đổi vị trí thị giác của icon
              constraints: BoxConstraints(
                minWidth: context.icon(44),
                minHeight: context.icon(44),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
