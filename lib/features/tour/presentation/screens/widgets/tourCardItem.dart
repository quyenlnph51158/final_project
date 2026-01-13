import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              tour.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stackTrace) =>
                  Container(
                      height: 200,
                      color: Colors.grey,
                      alignment: Alignment.center,
                      child: const Icon(Icons.error, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tour.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  // Dùng mainAxisAlignment.spaceBetween để đẩy hai nhóm ra hai phía
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. Nhóm bên trái (Thời lượng chuyến đi)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          tour.duration,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    // 2. Nhóm bên phải (Lượng sao đánh giá)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        Text(
                          tour.reviewsCount.toString(), // Giá trị đánh giá
                          style: const TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star_border,
                          size: 18,
                          color: Colors.amber, // Màu vàng cho icon sao
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tour.price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.goToTourDetail(context,tour);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(l10n.general_detailButton,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
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