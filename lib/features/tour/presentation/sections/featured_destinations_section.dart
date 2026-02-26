import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../controller/travel_booking_controller.dart';
import '../widgets/destination_card.dart';


class FeaturedDestinationSection extends StatelessWidget{
  const FeaturedDestinationSection({super.key});
  Widget build(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    final controller=context.watch<TravelBookingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppLayoutSpacing.paddingDestinationSection,
          child:Center(
            child: Text(
              l10n.home_destinationsTitle,
              style: AppStyles.titleCategory,
            ),
          ),
        ),
        SizedBox(
          height: AppSizes.destinationListHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppLayoutSpacing.paddingCategoryCard,
            itemCount: controller.state.tour.categories.length,
            itemBuilder: (context, index) {
              final categories = controller.state.tour.categories[index];
              return DestinationCard(category: categories,);
            },
          ),
        ),
      ],
    );
  }
}