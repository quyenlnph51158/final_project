import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../controller/travel_booking_controller.dart';
import '../input/date_field.dart';
import '../input/flight_train_location_input.dart';
import '../input/passenger_input_field.dart';
import '../modals/passenger_selection_modal.dart';
import '../widgets/search_button.dart';
import '../widgets/trip_type_button.dart';

class LocationData{
  final String label;
  final String code;
  LocationData({required this.label, required this.code});

}

class TrainSearchForm extends StatelessWidget{
  const TrainSearchForm({super.key});
  @override
  Widget build(BuildContext context) {
    final List<LocationData> trains= [LocationData(label: 'Ga Hà Nội', code: 'SHN'),
      LocationData(label: 'Ga Đà Nẵng', code: 'SDN')];
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    return Column(
        children: [
          _buildTripTypeSelector(context),
          const SizedBox(height: 16),
          FlightTrainLocationInput(
            label: l10n.form_labelFlightWhereGo,
            value: l10n.form_labelTrainDeparture,
            icon: Icons.train_outlined,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          FlightTrainLocationInput(
              label: l10n.form_labelTrainWhereArrive,
              value:  l10n.form_labelTrainArrival,
              icon:  Icons.directions_railway_outlined,
              onTap: () {},
          ),
          const SizedBox(height: 16),
          Row(
          children: [
            Expanded(
                child: DateField(
                  label:  l10n.form_labelDepartureDate,
                  value:  controller.state.selectedDate.toString(),
                  onTap: () {
                    controller.selectDate(context, isReturnDate: false);
                  },
                )
            ),
          const SizedBox(width: 8),
          if (controller.state.isRoundTrip)
            Expanded(
                child: DateField(
                  label:  l10n.form_labelFlightReturnDate,
                  value:  controller.state.returnDate.toString(),
                  onTap: () {
                    controller.selectDate(context, isReturnDate: true);
                  },
                )
            ),
            ],
          ),
          const SizedBox(height: 16),
          PassengerInputField(
            adultCount: controller.state.adultCount,
            childCount: controller.state.childCount,
            infantCount: controller.state.infantCount,
            selectedClass: controller.state.selectedClass,
            onTap: () => PassengerSelectionModal(controller:  controller),
          ),
          const SizedBox(height: 20),
          SearchButton(text: l10n.form_searchTrainButton),

        ],
    );
  }
  Widget _buildTripTypeSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    return Row(
      children: [
        TripTypeButton(
            text: l10n.form_tripRoundTrip,
            isSelected: controller.state.isRoundTrip == true,
            onPressed: () => controller.updateTripType(true),
        ),
        const SizedBox(width: 10),
        TripTypeButton(
            text: l10n.form_tripOneWay,
            isSelected: controller.state.isRoundTrip == false,
            onPressed: () => controller.updateTripType(true),
        ),
      ],
    );
  }
}