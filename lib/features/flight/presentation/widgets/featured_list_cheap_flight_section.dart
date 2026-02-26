import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../controller/flight_controller.dart';
import 'cheap_flight_card.dart';
import 'package:flutter/material.dart';

class FeaturedListCheapFlightSection extends StatelessWidget{
  const FeaturedListCheapFlightSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<FlightController>();
    final state = controller.state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.flight_viewLatestDeals,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          if (state.listCheapFlight.isEmpty && !state.isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(l10n.flight_noFlightsFound,
                    style: TextStyle(fontSize: 28, color: Colors.red)),
              ),
            )
          else if(state.isLoading)
            const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          else
            ListView.builder(
              controller: controller.scrollController, // ⭐ QUAN TRỌNG
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.listCheapFlight.length,
              itemBuilder: (context, index) {
                final flight = state.listCheapFlight[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: CheapFlightCard(flight: flight),
                );
              },
            ),

        ],
      ),
    );
  }
}