import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/shared/app_layout_spacing.dart';
import '../../../../../core/design/tour/tour_layout_spacing.dart';
import '../../controller/travel_booking_controller.dart';
import '../../widgets/tour_card_item.dart';

class FeaturedTourSection extends StatelessWidget{
  const FeaturedTourSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller=context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: TourLayoutSpacing.paddingFeaturedTourSection(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: AppStyles.tourSectionVibe(context),
            ),
          ),
          Center(
            child: Text(
              controller.state.ui.isSearching
                  ? '${l10n.home_tourSectionTitleSearch} ${controller.state.form.destination}'
                  : l10n.home_tourSectionTitleFeatured,
              style: AppStyles.tourSectionTitle(context),
            ),
          ),
          SharedAppLayoutSpacing.labelandCard,
          if (controller.state.tour.initialList.isEmpty)
            Center(
              child: Padding(
                padding: TourLayoutSpacing.paddingTourCardError(context),
                child: Text(l10n.error_tourNotFound,
                    style: AppStyles.errorNotFound(context)),
              ),
            )
          else
            ...controller.state.tour.initialList.where((x)=> x.avarageRating == 5).take(3).map((tour) {
              return Padding(
                padding: TourLayoutSpacing.paddingTourCard(context),
                child: TourCardItem(tour: tour,),
              );
            }).toList(),
        ],
      ),
    );
  }
}