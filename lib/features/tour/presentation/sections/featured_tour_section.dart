import 'package:final_project/core/design/tour/app_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/presentation/widgets/pagination_control.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../controller/travel_booking_controller.dart';
import '../widgets/tour_card_item.dart';

class FeaturedTourSection extends StatelessWidget{
  const FeaturedTourSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller=context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: AppLayoutSpacing.paddingFeaturedTourSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: AppStyles.tourSectionVibe,
            ),
          ),
          Center(
            child: Text(
              controller.state.ui.isSearching
                  ? '${l10n.home_tourSectionTitleSearch} ${controller.state.form.destination}'
                  : l10n.home_tourSectionTitleFeatured,
              style: AppStyles.tourSectionTitle,
            ),
          ),
          AppLayoutSpacing.labelandCard,
          if (controller.state.tour.initialList.isEmpty)
            Center(
              child: Padding(
                padding: AppLayoutSpacing.paddingTourCardError,
                child: Text(l10n.error_tourNotFound,
                    style: AppStyles.errorNotFound),
              ),
            )
          else
            ...controller.state.tour.initialList.where((x)=> x.reviewsCount == 5).take(3).map((tour) {
              return Padding(
                padding: AppLayoutSpacing.paddingTourCard,
                child: TourCardItem(tour: tour,),
              );
            }).toList(),
        ],
      ),
    );
  }
}