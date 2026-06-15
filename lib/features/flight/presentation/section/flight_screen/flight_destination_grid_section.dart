import 'package:flutter/material.dart';
import '../../../../../core/data/constants/international_destination_data.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../widgets/flight_screen/inter_destination_item.dart';

class FlightDestinationGridSection extends StatelessWidget {
  const FlightDestinationGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final dest = InternationalDestinationData.interDestination[index];

          return DestinationItem(destination: dest, itemWidth: double.infinity);
        }, childCount: InternationalDestinationData.interDestination.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: context.rw(12.0),
          mainAxisSpacing: context.rw(12.0),
          childAspectRatio: 2.0,
        ),
      ),
    );
  }
}
