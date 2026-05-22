import 'package:flutter/material.dart';
import '../../../../../core/data/constants/international_destination_data.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../widgets/flight_screen/inter_destination_item.dart';

class FlightDestinationGridSection extends StatelessWidget {
  const FlightDestinationGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: FlightLayoutSpacing.gridHorizontalPadding(context),
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final dest = InternationalDestinationData.interDestination[index];

          return DestinationItem(destination: dest, itemWidth: double.infinity);
        }, childCount: InternationalDestinationData.interDestination.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: FlightLayoutSpacing.gridGap(context),
          mainAxisSpacing: FlightLayoutSpacing.gridGap(context),
          childAspectRatio: FlightSize.destinationAspectRatio,
        ),
      ),
    );
  }
}
