import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../controller/flight_controller.dart';

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
        final isSelected = state.ui.selectedFlightTab == tab;

        final icon = tab == FlightTab.flight
            ? Icons.flight_outlined
            : Icons.tag_outlined;

        final text = tab == FlightTab.flight
            ? l10n.menu_tabFlight
            : l10n.flight_seatCode;

        return Expanded(
          child: InkWell(
            onTap: () => controller.selectFlightTab(tab, l10n),
            child: Container(
              padding: FlightLayoutSpacing.tabItemPadding,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? kPrimaryColor : Colors.transparent,
                    width: FlightSize.tabIndicatorHeight,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(icon, color: isSelected ? kPrimaryColor : Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: FlightStyle.tabLabel(
                      context,
                      isSelected: isSelected,
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
