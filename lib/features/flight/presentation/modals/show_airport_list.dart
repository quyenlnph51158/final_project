import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import '../controller/flight_controller.dart';

class ShowAirportList extends StatelessWidget {
  final bool isDeparture;
  final IconData icon;
  final FlightController  controller;

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
        final filteredList =
        controller.filteredAirports(searchController.text,);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              // Handle + title
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      modalTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => modalSetState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.form_labelSearchHint,
                    prefixIcon:
                    const Icon(Icons.search, color: kPrimaryColor),
                    filled: true,
                    fillColor: kFormFieldBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
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
                        ? item.label == state.departure
                        : item.label == state.destination;

                    return ListTile(
                      leading: Icon(icon, color: kPrimaryColor),
                      title: Text(item.label),
                      trailing: isSelected
                          ? const Icon(Icons.check,
                          color: kPrimaryColor)
                          : null,
                      onTap: () {
                        controller.selectAirport(isDeparture: isDeparture,airport: item);
                        Navigator.pop(context);
                      },
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
