import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;

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
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: SizedBox(
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Image
            Image.network(
              service['imageUrl'],
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
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    service['subtitle'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 2),
                      ],
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
