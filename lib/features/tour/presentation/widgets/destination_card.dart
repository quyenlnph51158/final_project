import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../app/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<TravelBookingController>();

    return Container(
      width: AppSizes.imageCategory,
      margin: AppLayoutSpacing.marginDestinationCard,
      child: InkWell(
        onTap: () {
          // ✅ GỌI CONTROLLER – KHÔNG setState
          controller.onDestinationSelected(category.name, l10n.form_defaultDestination);
          controller.goToTourScreen();
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  category.image,
                  width: AppSizes.imageCategory,
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
              padding: AppLayoutSpacing.categoryNameAndImage,
              child: Center(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.categoryName
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
