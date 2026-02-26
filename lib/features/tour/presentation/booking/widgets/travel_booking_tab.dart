import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
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
    final selectedTab = context.select<TravelBookingController, TravelTab>(
        (c)=>c.state.ui.selectedTab
    );

    return Row(
      children: TravelTab.values.map((tab) {
        final isSelected = selectedTab == tab;

        final (icon, text) = switch (tab) {
          TravelTab.tour => (
            Icons.luggage_outlined,
            l10n.menu_tabTour,
          ),
          TravelTab.flight => (
            Icons.flight_outlined,
            l10n.menu_tabFlight,
          ),
          TravelTab.train =>(
              Icons.train_outlined,
            l10n.menu_tabTrain
          ),
        };

        return Expanded(
          child: InkWell(
            onTap: () {
              context
                  .read<TravelBookingController>()
                  .changeTab(tab, l10n);
            },
            child: Container(
              padding: AppLayoutSpacing.paddingtabform,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? kPrimaryColor
                        : Colors.transparent,
                    width: AppSizes.wTabBorder  ,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      color:
                      isSelected ? kPrimaryColor : kNullValue),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: AppStyles.textTab,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                      isSelected ? kPrimaryColor : kNullValue,
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