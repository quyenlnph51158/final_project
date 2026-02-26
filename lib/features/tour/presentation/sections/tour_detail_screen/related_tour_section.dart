import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/features/tour/data/models/tour_detail.dart';
import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/shared/app_layout_spacing.dart';
import '../../../../../core/design/tour/tour_layout_spacing.dart';
import '../../controller/travel_booking_controller.dart';
import '../../widgets/tour_card_item.dart';

class RelatedTourSection extends StatelessWidget {
  final TourDetail tourDetail;

  const RelatedTourSection({
    super.key,
    required this.tourDetail,
  });

  @override
  Widget build(BuildContext context) {
    final tours = context.select<TravelBookingController, List<TourItem>>(
          (c) => c.state.tour.initialList,
    );

    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: TourLayoutSpacing.paddingTourCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.tour_detail_you_should_consult,
              style: AppStyles.tourSectionTitle(context),
            ),
          ),
          SharedAppLayoutSpacing.labelandCard,
          ...tours.where((tour) => tour.id != tourDetail.id && tour.avarageRating==5).take(5).toList().map((tour) {
            return Padding(
              padding: TourLayoutSpacing.bottomTourCardItem(context),
              child: TourCardItem(tour: tour,),
            );
          }).toList(),
        ],
      ),
    );
  }
}
