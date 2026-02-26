import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/flight/presentation/modals/passenger_selection%20_flightScreen_modal.dart';
import 'package:final_project/features/flight/presentation/modals/show_airport_list.dart';
import 'package:final_project/features/flight/presentation/widgets/search_flight_button.dart';
import 'package:final_project/shared/widgets/form_field_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../tour/presentation/booking/input/date_field.dart';
import '../../../tour/presentation/booking/input/flight_train_location_input.dart';
import '../../../tour/presentation/booking/input/passenger_input_field.dart';
import '../../../tour/presentation/booking/widgets/trip_type_button.dart';

class FlightForm extends StatelessWidget {
  const FlightForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Lắng nghe sự thay đổi từ controller
    final controller = context.read<FlightController>();
    final state = context.watch<FlightController>().state;
    return Column(
      children: [
        // 2. Chọn loại vé (Khứ hồi/Một chiều)
        Row(
          children: [
            TripTypeButton(
              text: l10n.form_tripRoundTrip,
              isSelected: state.roundTrip==true,
              onPressed: () => controller.updateTripType(true,l10n),
            ),
            const SizedBox(width: 10),
            TripTypeButton(
              text: l10n.form_tripOneWay,
              isSelected: state.roundTrip==false,
              onPressed: () => controller.updateTripType(false,l10n),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 3. Điểm khởi hành
        FormFieldWrapper(
          child: FlightTrainLocationInput(
            label: l10n.form_labelFlightDeparture,
            // Hiển thị tên sân bay đã chọn hoặc gợi ý "Đi đâu?"
            hint: l10n.form_labelFlightWhereGo,
            value: state.departure,
            icon: Icons.airplanemode_on_outlined,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: kBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => ShowAirportList(
                  isDeparture: true, // true cho điểm đi, false cho điểm đến
                  icon: Icons.airplanemode_on_outlined,
                  controller: controller, // Truyền controller hiện tại vào
                ),
              );
            },
          ),
        ),

        // 4. Điểm đến
        FormFieldWrapper(
          child: FlightTrainLocationInput(
            label: l10n.form_labelFlightArrival,
            hint: l10n.form_labelFlightWhereArrive,
            value:state.destination,
            icon: Icons.airplanemode_off_outlined,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => ShowAirportList(
                  isDeparture: false, // true cho điểm đi, false cho điểm đến
                  icon: Icons.airplanemode_off_outlined,
                  controller: controller, // Truyền controller hiện tại vào
                ),
              );
            },
          ),
        ),

        // 5. Chọn ngày
        FormFieldWrapper(
          child: Row(
            children: [
              Expanded(
                child: DateField(
                  label: l10n.form_labelDepartureDate,
                  hintText: '',
                  value: state.selectedDate,
                  onTap: () => _pickDate(context, controller, isReturnDate: false),
                ),
              ),
              if (state.roundTrip) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: DateField(
                    label: l10n.form_labelFlightReturnDate,
                    hintText: l10n.form_defaultReturnDate,
                    value: state.returnDate ?? '',
                    onTap: () => _pickDate(context, controller, isReturnDate: true),
                  ),
                ),
              ],
            ],
          ),
        ),

        // 6. Nhập thông tin hành khách & Hạng ghế
        FormFieldWrapper(
          child: PassengerInputField(
            adultCount: state.adultCount,
            childCount: state.childCount,
            infantCount: state.infantCount,
            onTap: () => _showPassengerModal(context, controller),
          ),
        ),

        const SizedBox(height: 20),

        // 7. Nút tìm kiếm
        SearchFlightButton(text: l10n.form_searchFlightButton),
      ],
    );
  }

  void _showPassengerModal(BuildContext context, FlightController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PassengerSelectionFlightscreenModal(controller: controller),
    );
  }
  Future<void> _pickDate(
      BuildContext context,
      FlightController controller, {
        required bool isReturnDate,
      }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final formatted =
          "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";

      controller.setDate(
        isReturnDate: isReturnDate,
        formattedDate: formatted,
      );
    }
  }

}