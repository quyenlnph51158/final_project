import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../controller/travel_booking_controller.dart';
import '../widgets/pagination_control.dart';
import '../widgets/tourCardItem.dart';

class FeaturedTourSection extends StatelessWidget{
  
  const FeaturedTourSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller=context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: TextStyle(
                fontFamily: 'GreatVibes',
                fontSize: 24,
                color: Color(0xFF00796B),
              ),
            ),
          ),
          Center(
            child: Text(
              controller.state.isSearching
                  ? '${l10n.home_tourSectionTitleSearch} ${controller.state.destination}'
                  : l10n.home_tourSectionTitleFeatured,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (controller.currentTours.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(l10n.error_tourNotFound,
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            )
          else
            ...controller.currentTours.map((tour) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TourCardItem(tour: tour,),
              );
            }).toList(),
          PaginationControl(),
        ],
      ),
    );
  }
}