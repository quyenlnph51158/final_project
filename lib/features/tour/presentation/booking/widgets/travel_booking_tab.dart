import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../controller/travel_booking_controller.dart';

class TravelBookingTab extends StatelessWidget {
  const TravelBookingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedTab = context.select<TravelBookingController, TravelTab>(
      (c) => c.state.ui.selectedTab,
    );

    return Row(
      children: TravelTab.values.map((tab) {
        final isSelected = selectedTab == tab;

        final (icon, text) = switch (tab) {
          TravelTab.tour => (Icons.luggage_outlined, l10n.menu_tabTour),
          TravelTab.flight => (Icons.flight_outlined, l10n.menu_tabFlight),
          TravelTab.train => (Icons.train_outlined, l10n.menu_tabTrain),
        };

        return Expanded(
          child: InkWell(
            onTap: () {
              context.read<TravelBookingController>().changeTab(tab, l10n);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: context.rh(10)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? kPrimaryColor : Colors.transparent,
                    width: context.rw(3.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: isSelected ? kPrimaryColor : kNullValue),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? kPrimaryColor : kNullValue,
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
