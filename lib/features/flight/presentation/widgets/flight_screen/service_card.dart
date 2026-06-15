import 'package:final_project/core/data/model/extra_service_model.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../../../../core/utils/responsive_layout.dart';

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
        borderRadius: BorderRadius.circular(context.sp(16)),
      ),
      elevation: 4,
      child: SizedBox(
        height: context.rh(240),
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
              left: context.rw(20.0),
              right: context.rw(20.0),
              bottom: context.rw(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.sp(28),
                      fontWeight: FontWeight.bold,
                      shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  ),
                  SizedBox(height: context.rw(8.0) / 2),
                  Text(
                    service.subTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.sp(16),
                      shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
                    ),
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
