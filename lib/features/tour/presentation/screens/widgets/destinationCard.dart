import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../data/models/tour_category.dart';
import '../controller/travel_booking_controller.dart';


class DestinationCard extends StatelessWidget {
  final TourCategory category;

  const DestinationCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<TravelBookingController>();

    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          // ✅ GỌI CONTROLLER – KHÔNG setState
          controller.onDestinationSelected(context,category.name,l10n.form_defaultDestination);

          // ✅ UI xử lý SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${l10n.home_destinationSnackbar} ${category.name}',
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  category.image,
                  width: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
