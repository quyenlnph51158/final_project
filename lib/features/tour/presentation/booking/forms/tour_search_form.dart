import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/date_picker.dart';
import '../../../../../shared/widgets/form_field_wrapper.dart';
import '../../controller/travel_booking_controller.dart';
import '../input/date_field.dart';
import '../input/input_field.dart';
import '../input/location_selection_field.dart';
import '../widgets/search_button.dart';

class TourSearchForm extends StatelessWidget {
  final VoidCallback onSearch;
  const TourSearchForm({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Optimization: Only rebuild if these specific values change
    final destination = context.select((TravelBookingController c) => c.state.form.tempDestination);
    final selectedDate = context.select((TravelBookingController c) => c.state.form.selectedDate);

    // Get the controller once without listening (use read)
    final controller = context.read<TravelBookingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        FormFieldWrapper(
          child: LocationSelectionField(
            label: l10n.form_defaultDestination,
            currentValue: destination,
          ),
        ),

        FormFieldWrapper(
          child: DateField(
            label: l10n.form_labelDepartureDate,
            hintText: '',
            value: selectedDate,
            onTap: () => DatePicker.pickDate(
              context: context,
              onDateSelected: ( formattedDate, originalDate){
                // Gọi hàm cập nhật date của Tour Controller
                controller.setDepartureDate(formattedDate);
              }
            ),
          ),
        ),

        FormFieldWrapper(
          child: InputField(
            label: l10n.form_labelDeparturePlace,
            hint: l10n.form_defaultDeparture,
            controller: controller.departureController,
            onChanged: (value) {
              return controller.updateDeparture(value);
            }
          ),
        ),

        TourLayoutSpacing.fieldAndButton,

        SearchButton(
          text: l10n.form_searchTourButton,
          onPressed: onSearch,
        ),
      ],
    );
  }
}
