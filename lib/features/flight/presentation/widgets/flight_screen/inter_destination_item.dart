import 'package:final_project/core/data/model/international_destination_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';

class DestinationItem extends StatelessWidget {
  final InternationalDestinationModel destination;
  final double itemWidth;

  const DestinationItem({
    super.key,
    required this.destination,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(FlightLayoutSpacing.destinationPadding),
      // **Không sử dụng InkWell/GestureDetector**
      child: Container(
        width: itemWidth,
        height: FlightSize.destinationCardHeight(context),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: FlightShape.borderRadiusSmall(context),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Hình ảnh
            Image.network(
              destination.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),

            // 2. Lớp phủ (Overlay)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),

            // 3. Tên điểm đến (Định vị ở dưới cùng)
            Positioned(
              bottom: FlightLayoutSpacing.destinationContentOffset,
              left: FlightLayoutSpacing.destinationContentOffset,
              right: FlightLayoutSpacing.destinationContentOffset,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.name,
                    style: FlightStyle.destinationTitle(context),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: FlightLayoutSpacing.gapSmall(context) / 2,
                    ),
                    width: FlightSize.destinationIndicatorWidth,
                    height: FlightSize.destinationIndicatorHeight,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
