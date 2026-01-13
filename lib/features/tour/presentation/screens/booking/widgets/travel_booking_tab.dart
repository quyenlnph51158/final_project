import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../controller/travel_booking_controller.dart';

class TravelBookingTab extends StatelessWidget{
  const TravelBookingTab({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    final selectedTab = controller.state.selectedTab;

    return Row(
      children: TravelTab.values.map((tab) {
        final isSelected = selectedTab == tab;
        final icon = switch (tab) {
          TravelTab.tour => Icons.luggage_outlined,
          TravelTab.flight => Icons.flight_outlined,
          TravelTab.train => Icons.train_outlined,
        };

        final text = switch (tab) {
          TravelTab.tour => l10n.menu_tabTour,
          TravelTab.flight => l10n.menu_tabFlight,
          TravelTab.train => l10n.menu_tabTrain,
        };

        return Expanded(
          child: InkWell(
            onTap: () {
              context
                  .read<TravelBookingController>()
                  .changeTab(tab, l10n);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? kPrimaryColor
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(icon,
                      color:
                      isSelected ? kPrimaryColor : Colors.grey),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                      isSelected ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}