import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../data/models/tour_category.dart';
import '../controller/travel_booking_controller.dart';


class DestinationCard extends StatelessWidget {
  final TourCategory category;

  const DestinationCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TravelBookingController>();

    return Container(
      width: context.rw(130),
      margin: EdgeInsets.symmetric(horizontal: context.rw(4)),
      child: InkWell(
        onTap: () {
          // ✅ GỌI CONTROLLER – KHÔNG setState
          controller.toggleTourTypeFilter(category.id);
          controller.applyFilters();
          controller.goToTourScreen();
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  category.image,
                  width: context.rw(130),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: kIconErrorColor,
                    alignment: Alignment.center,
                    child: AppIcons.error,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: context.rh(4)),
              child: Center(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(20))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
