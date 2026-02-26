import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/list_cheap_flight.dart';
import '../controller/flight_controller.dart';

class CheapFlightCard extends StatelessWidget {
  final ListCheapFlight flight;

  const CheapFlightCard({
    super.key,
    required this.flight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<FlightController>();

    final originCode = flight.originAirportObject.value;
    final originName = flight.originAirportObject.label;
    final destinationCode = flight.destinationAirportObject.value;
    final destinationName = flight.destinationAirportObject.label;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _image(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.flight_from}$originName${l10n.flight_to}$destinationName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _flightType(l10n),
                const Divider(height: 24),
                Text(
                  l10n.flight_label_only_from,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      flight.price.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.departureCodeSelected(
                            originCode,
                            destinationCode,
                            originName,
                            destinationName,
                            FlightTab.flight,
                            l10n,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.general_detailButton,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        flight.image,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Icon(Icons.error, color: Colors.white),
        ),
      ),
    );
  }

  Widget _flightType(AppLocalizations l10n) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          flight.type == 'OW'
              ? l10n.form_tripOneWay
              : flight.type == 'RT'
              ? l10n.form_tripRoundTrip
              : flight.type,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

