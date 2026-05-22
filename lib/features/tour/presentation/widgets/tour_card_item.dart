import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/tour_dividers.dart';
import 'package:final_project/core/design/tour/tour_elevation.dart';
import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/design/tour/tour_sizes.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/design/tour/tour_layout_spacing.dart';
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
      elevation: TourElevation.tourCardItemElevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppShape.imageInCard,
            child: Image.network(
              tour.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AppSizes.imageTourCardItem(context),
              errorBuilder: (context, error, stackTrace) =>
                Container(
                  height: AppSizes.errorLoadImageCardItem(context),
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: AppIcons.error,
                ),
            ),
          ),
          Padding(
            padding: TourLayoutSpacing.tourCardItemContent(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: AppStyles.tourNameCardItem(context)
                ),
                SizedBox(height: TourLayoutSpacing.tourNameAndTourDescription(context)),
                Text(
                  tour.description,
                  style: AppStyles.tourDescriptionCardItem(context),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: TourLayoutSpacing.tourNameAndTourDescription(context)),
                Row(
                  // Dùng mainAxisAlignment.spaceBetween để đẩy hai nhóm ra hai phía
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 1. Nhóm bên trái (Thời lượng chuyến đi)
                    Row(
                      mainAxisSize: MainAxisSize.min, // Giữ cho Row này chỉ chiếm diện tích cần thiết
                      children: [
                        AppIcons.duration,
                        SizedBox(height: TourLayoutSpacing.durationIconAndValue(context)),
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
                          tour.avarageRating.toString(), // Giá trị đánh giá
                          style: AppStyles.reviewCountValue(context),
                        ),
                        SizedBox(height: TourLayoutSpacing.averageRatingAndStar(context)),
                        AppIcons.tourCardItemStar
                      ],
                    ),
                  ],
                ),
                TourDividers.tourCardItem,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tour.price,
                      style: AppStyles.priceValue(context),
                    ),

                    SizedBox(
                      height: AppSizes.tourCardItemButton(context),
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