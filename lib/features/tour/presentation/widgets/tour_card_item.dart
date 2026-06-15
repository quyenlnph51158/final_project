import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/travel_booking_controller.dart';

class TourCardItem extends StatelessWidget{
  final TourItem tour;
  const TourCardItem ({
    super.key,
    required this.tour,
  });
  @override
  Widget build(BuildContext context){
    final controller = context.read<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: kFormFieldBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)
      ),
      elevation: context.rw(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              tour.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: context.rh(200),
              errorBuilder: (context, error, stackTrace) =>
                Container(
                  height: context.rh(200),
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: AppIcons.error,
                ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.rw(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold)
                ),
                SizedBox(height: context.rh(8)),
                Text(
                  tour.description,
                  style: TextStyle(fontSize: context.sp(14), color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.rh(8)),
                Row(
                  // Dùng mainAxisAlignment.spaceBetween để đẩy hai nhóm ra hai phía
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. Nhóm bên trái (Thời lượng chuyến đi)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        AppIcons.duration,
                        SizedBox(height: context.rh(4)),
                        Text(
                          tour.duration,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    // 2. Nhóm bên phải (Lượng sao đánh giá)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        Text(
                          tour.avarageRating.toString(), // Giá trị đánh giá
                          style: TextStyle(color: Colors.black87, fontSize: context.sp(16)),
                        ),
                        SizedBox(height: context.rh(4)),
                        AppIcons.tourCardItemStar
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: context.rh(24), // Scale chiều cao của divider theo thiết kế
                  thickness: 1, // Độ dày thường giữ nguyên để tránh răng cưa
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tour.price,
                      style: TextStyle(
                        fontSize: context.sp(20),
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                    ),

                    SizedBox(
                      height: context.rh(40),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.goToTourDetail(tour,l10n);
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          l10n.general_detailButton,
                          style: TextStyle(color: kTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}