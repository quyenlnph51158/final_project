import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../controller/flight_controller.dart';

class FlightTabsWidget extends StatelessWidget {
  const FlightTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FlightController>();
    final state = controller.state;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: FlightTab.values.map((tab) {
        final isSelected =
            state.selectedFlightTab == tab;

        final icon = tab == FlightTab.flight
            ? Icons.flight_outlined
            : Icons.tag_outlined;

        final text = tab == FlightTab.flight
            ? l10n.menu_tabFlight
            : l10n.flight_seatCode;

        return Expanded(
          child: InkWell(
            onTap: () =>
                controller.selectFlightTab(tab, l10n),
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 10),
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
                  Icon(
                    icon,
                    color: isSelected
                        ? kPrimaryColor
                        : Colors.grey,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? kPrimaryColor
                          : Colors.grey,
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
