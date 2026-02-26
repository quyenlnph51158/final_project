import 'package:final_project/core/data/model/extra_service_model.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';

class ServiceCard extends StatelessWidget {
  final ExtraServiceModel service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: FlightShape.borderRadiusLarge(context),
      ),
      elevation: 4,
      child: SizedBox(
        height: FlightSize.serviceCardHeight(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Image
            Image.network(
              service.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: Text(l10n.error_image_load),
                );
              },
            ),

            /// Gradient
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.6, 1.0],
                  ),
                ),
              ),
            ),

            /// Text
            Positioned(
              left: FlightLayoutSpacing.overlayPadding(context),
              right: FlightLayoutSpacing.overlayPadding(context),
              bottom: FlightLayoutSpacing.overlayPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: FlightStyle.cardTitleOverlay(context),
                  ),
                  SizedBox(height: FlightLayoutSpacing.gapSmall(context) / 2),
                  Text(
                    service.subTitle,
                    style: FlightStyle.cardSubTitleOverlay(context),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
