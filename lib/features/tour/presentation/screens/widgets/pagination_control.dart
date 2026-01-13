import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../controller/travel_booking_controller.dart';

class PaginationControl extends StatefulWidget {
  const PaginationControl({super.key,});

  @override
  State<PaginationControl> createState() => _PaginationControlState();
}

class _PaginationControlState extends State<PaginationControl> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller=context.watch<TravelBookingController>();
    if (controller.state.tourList.length <= controller.state.pageSize) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            label: Text(l10n.tour_detail_prev),
            onPressed: controller.state.currentPage > 1
                ? controller.previousPage
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: kPrimaryColor,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(width: 20),
          Text(
            l10n.tour_detail_page_info(controller.state.currentPage, controller.totalPages),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            label: Text(l10n.tour_detail_next),
            onPressed: controller.state.currentPage < controller.totalPages
                ? controller.nextPage
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: kPrimaryColor,
              backgroundColor: Colors.white,
            ),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}