import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/utils/date_picker.dart';
import '../../../../tour/presentation/booking/input/date_field.dart';
import '../../../../flight/presentation/state/flight_state.dart';
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';

class FlightDatePickerSection extends StatelessWidget {
  final FlightController controller;
  final FlightState state;

  const FlightDatePickerSection({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Ô chọn ngày đi (Luôn luôn có)
        Expanded(
          child: DateField(
            label: l10n.form_labelDepartureDate,
            hintText: '',
            value: state.criteria.departureDate,
            onTap: () => DatePicker.pickDate(
              context: context,
              onDateSelected: (formattedDate, originalDate) {
                // Gọi hàm cập nhật date của Tour Controller
                controller.setDate(
                  isReturnDate: false,
                  formattedDate: formattedDate,
                );
              },
            ),
          ),
        ),

        // Ô chọn ngày về (Chỉ hiện khi là Round Trip)
        if (state.criteria.roundTrip) ...[
          SizedBox(width: FlightLayoutSpacing.gapInputHorizontal(context)),
          Expanded(
            child: DateField(
              label: l10n.form_labelFlightReturnDate,
              hintText: l10n.form_defaultReturnDate,
              value: state.criteria.returnDate ?? '',
              onTap: () => DatePicker.pickDate(
                context: context,
                onDateSelected: (formattedDate, originalDate) {
                  // Gọi hàm cập nhật date của Tour Controller
                  controller.setDate(
                    isReturnDate: true,
                    formattedDate: formattedDate,
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
