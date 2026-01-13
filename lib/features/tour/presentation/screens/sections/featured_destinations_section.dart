import 'package:flutter/cupertino.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../controller/travel_booking_controller.dart';
import '../widgets/destinationCard.dart';


class FeaturedDestinationSection extends StatelessWidget{
  const FeaturedDestinationSection({super.key});
  Widget build(BuildContext context){
    final l10n = AppLocalizations.of(context)!;
    final controller=context.watch<TravelBookingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
          child: Text(
            l10n.home_destinationsTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: controller.state.tourCategories.length,
            itemBuilder: (context, index) {
              final categories = controller.state.tourCategories[index];
              return DestinationCard(category: categories,);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}