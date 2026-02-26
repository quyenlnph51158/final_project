import 'package:final_project/shared/widgets/form_field_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/date_picker.dart';
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
          FormFieldWrapper(
            child: FlightTrainLocationInput(
              label: l10n.form_labelTrainDeparture,
              value: l10n.form_labelFlightWhereGo,
              icon: Icons.train_outlined,
              onTap: () {},
            ),
          ),
          FormFieldWrapper(
            child: FlightTrainLocationInput(
              label: l10n.form_labelTrainArrival,
              hint: l10n.form_labelTrainWhereArrive,
              value:  '',
              icon:  Icons.directions_railway_outlined,
              onTap: () {},
            ),
          ),
          FormFieldWrapper(
            child: Row(
              children: [
                Expanded(
                    child: DateField(
                      label:  l10n.form_labelDepartureDate,
                      hintText: '',
                      value:  controller.state.form.selectedDate.toString(),
                        onTap: () async {
                          final picked = await DatePicker.pickDate(context);
                          if(picked !=null ) {
                            controller.setDate(picked,isReturnDate: false );
                          }
                        }
                    )
                ),
              const SizedBox(width: 8),
              if (controller.state.form.isRoundTrip)
                Expanded(
                    child: DateField(
                      label:  l10n.form_labelFlightReturnDate,
                      hintText: l10n.form_defaultReturnDate,
                      value:  controller.state.form.returnDate.toString(),
                      onTap: () async{
                        final picked = await DatePicker.pickDate(context);
                        if(picked != null){
                          controller.setDate(picked, isReturnDate: true);
                        }
                      }
                    )
                ),
                ],
              ),
          ),
          FormFieldWrapper(
            child:PassengerInputField(
              adultCount: controller.state.form.adultCount,
              childCount: controller.state.form.childCount,
              infantCount: controller.state.form.infantCount,
              onTap: () => PassengerSelectionModal(controller:  controller),
            ),
          ),
          SearchButton(
              text: l10n.form_searchTrainButton,
              onPressed: (){},
          ),

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
            isSelected: controller.state.form.isRoundTrip == true,
            onPressed: () => controller.updateTripType(true),
        ),
        const SizedBox(width: 10),
        TripTypeButton(
            text: l10n.form_tripOneWay,
            isSelected: controller.state.form.isRoundTrip == false,
            onPressed: () => controller.updateTripType(true),
        ),
      ],
    );
  }
}