import 'package:final_project/core/design/shared/app_layout_spacing.dart';
import 'package:final_project/core/design/shared/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../controller/flight_controller.dart';
import '../../widgets/flight_screen/cheap_flight_card.dart';
import 'package:flutter/material.dart';

class FeaturedListCheapFlightSection extends StatelessWidget{
  const FeaturedListCheapFlightSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<FlightController>();
    final state = controller.state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: FlightLayoutSpacing.screenHorizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.data.listCheapFlight.isEmpty && !state.ui.isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(FlightLayoutSpacing.emptyStatePadding(context)),                child: Text(l10n.flight_noFlightsFound,
                    style: FlightStyle.errorState(context)
                ),
              ),
            )
          else if (state.ui.isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: FlightLayoutSpacing.loadingVerticalPadding(context),
                ),
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                  strokeWidth: FlightSize.loadingIndicatorWidth(context),
                ),
              ),
            )

          else
            ListView.builder(
              padding: EdgeInsets.zero,
              controller: controller.scrollController, // ⭐ QUAN TRỌNG
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.data.listCheapFlight.length,
              itemBuilder: (context, index) {
                final flight = state.data.listCheapFlight[index];
                return Padding(
                  padding: EdgeInsets.zero,
                  child: CheapFlightCard(flight: flight),
                );
              },
            ),
        ],
      ),
    );
  }
}