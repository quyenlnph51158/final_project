import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_dividers.dart';
import 'package:final_project/core/design/tour/app_elevation.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
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
      shape: AppShape.card,
      elevation: AppElevation.tourCardItemElevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppShape.imageInCard,
            child: Image.network(
              tour.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AppSizes.imageTourCardItem,
              errorBuilder: (context, error, stackTrace) =>
                Container(
                  height: AppSizes.errorLoadImageCardItem,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: AppIcons.error,
                ),
            ),
          ),
          Padding(
            padding: AppLayoutSpacing.tourCardItemContent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: AppStyles.tourNameCardItem
                ),
                AppLayoutSpacing.tourNameAndTourDescription ,
                Text(
                  tour.description,
                  style: AppStyles.tourDescriptionCardItem,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                AppLayoutSpacing.tourNameAndTourDescription,
                Row(
                  // Dùng mainAxisAlignment.spaceBetween để đẩy hai nhóm ra hai phía
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. Nhóm bên trái (Thời lượng chuyến đi)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        AppIcons.duration,
                        AppLayoutSpacing.durationIconAndValue,
                        Text(
                          tour.duration,
                          style: AppStyles.durationIcon,
                        ),
                      ],
                    ),

                    // 2. Nhóm bên phải (Lượng sao đánh giá)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        Text(
                          tour.reviewsCount.toString(), // Giá trị đánh giá
                          style: AppStyles.reviewCountValue,
                        ),
                        AppLayoutSpacing.reviewscountAndStar,
                        AppIcons.tourCardItemStar
                      ],
                    ),
                  ],
                ),
                AppDividers.tourCardItem,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tour.price,
                      style: AppStyles.priceValue,
                    ),

                    SizedBox(
                      height: AppSizes.tourCardItemButton,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.goToTourDetail(tour,l10n);
                          },
                        style: AppStyles.cardItemButton,
                        child: Text(
                          l10n.general_detailButton,
                          style: AppStyles.textButton,
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