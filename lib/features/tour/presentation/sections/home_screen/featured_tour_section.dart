import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../controller/travel_booking_controller.dart';
import '../../widgets/tour_card_item.dart';

class FeaturedTourSection extends StatelessWidget{
  const FeaturedTourSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller=context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.home_tourSectionTitleVibes,
              style: GoogleFonts.bonheurRoyale(
                fontSize: context.sp(40),
                color: const Color(0xFF00796B),
              ),
            ),
          ),
          Center(
            child: Text(
              controller.state.ui.isSearching
                  ? '${l10n.home_tourSectionTitleSearch} ${controller.state.form.destination}'
                  : l10n.home_tourSectionTitleFeatured,
              style: TextStyle(
                fontSize: context.sp(28),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: context.rh(16)),
          if (controller.state.tour.initialList.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(context.rw(24)),
                child: Text(l10n.error_tourNotFound,
                    style: TextStyle(fontSize: context.sp(16), color: kError),
              ),
            ))
          else
            ...controller.state.tour.initialList.where((x)=> x.avarageRating == 5).take(3).map((tour) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.rh(16)),
                child: TourCardItem(tour: tour,),
              );
            }).toList(),
        ],
      ),
    );
  }
}