import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../core/design/flight/flight_shape.dart';
import '../../../../core/design/flight/flight_size.dart';
import '../../../../core/design/flight/flight_style.dart';
import '../controller/flight_controller.dart';

class ShowAirportList extends StatelessWidget {
  final bool isDeparture;
  final IconData icon;
  final FlightController controller;

  const ShowAirportList({
    super.key,
    required this.isDeparture,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = controller.state;

    final String modalTitle = isDeparture
        ? l10n.form_modalSelectAirportDeparture
        : l10n.form_modalSelectAirportArrival;

    final TextEditingController searchController = TextEditingController();

    return StatefulBuilder(
      builder: (context, modalSetState) {
        final filteredList = controller.filteredAirports(searchController.text);

        return SizedBox(
          height: FlightSize.airportModalHeight(context),
          child: Column(
            children: [
              // Handle + title
              Padding(
                padding: const EdgeInsets.all(FlightLayoutSpacing.modalPadding),
                child: Column(
                  children: [
                    Container(
                      height: FlightSize.dragHandleHeight,
                      width: FlightSize.dragHandleWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(
                          FlightSize.dragHandleHeight / 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(modalTitle, style: FlightStyle.modalTitle(context)),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FlightLayoutSpacing.searchPaddingH,
                  vertical: FlightLayoutSpacing.searchPaddingV,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => modalSetState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.form_labelSearchHint,
                    prefixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                      size: FlightSize.searchIconSize,
                    ),
                    filled: true,
                    fillColor: kFormFieldBackground,
                    border: OutlineInputBorder(
                      borderRadius: FlightShape.borderRadiusSmall(context),
                      borderSide: BorderSide(color: kBorderColor, width: 1),
                    ),
                  ),
                ),
              ),

              // Airport list
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];

                    final isSelected = isDeparture
                        ? item.label == state.criteria.departure
                        : item.label == state.criteria.destination;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            icon,
                            color: kPrimaryColor,
                            size: FlightSize.iconSizeSmall(context),
                          ),
                          title: Text(
                            item.label + " (${item.value})",
                            style: FlightStyle.airportItemTitle(context),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: kPrimaryColor)
                              : null,
                          onTap: () {
                            controller.selectAirport(
                              isDeparture: isDeparture,
                              airport: item,
                            );
                            Navigator.pop(context);
                          },
                        ),
                        Divider(thickness: 1, color: kBorderColor,)
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
