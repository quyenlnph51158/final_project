import 'package:final_project/features/tour/data/models/tour_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../controller/travel_booking_controller.dart';
import '../widgets/tourCardItem.dart';

class RelatedTourSection extends StatelessWidget {
  final TourDetail tourDetail;

  const RelatedTourSection({
    super.key,
    required this.tourDetail,
  });

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
              l10n.home_tourSectionTitleFeatured,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...controller.state.initialList.where((tour) => tour.id != tourDetail.id && tour.reviewsCount==5).take(5).toList().map((tour) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: TourCardItem(tour: tour,),
            );
          }).toList(),
        ],
      ),
    );
  }
}
