import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/flight/presentation/modals/show_airport_list.dart';
import 'package:final_project/features/flight/presentation/section/flight_screen/flight_date_picker_section.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_screen/search_flight_button.dart';
import 'package:final_project/shared/widgets/form_field_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../tour/presentation/booking/input/flight_train_location_input.dart';
import '../../../tour/presentation/booking/widgets/trip_type_button.dart';
import '../inputs/passenger_input_field.dart';
import '../modals/passenger_selection_flightScreen_modal.dart';

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
              isSelected: state.criteria.roundTrip==true,
              onPressed: () => controller.updateTripType(true),
            ),
            SizedBox(width: context.rw(10.0)),
            TripTypeButton(
              text: l10n.form_tripOneWay,
              isSelected: state.criteria.roundTrip==false,
              onPressed: () => controller.updateTripType(false),
            ),
          ],
        ),
        SizedBox(height: context.rh(16.0)),
        // 3. Điểm khởi hành
        FormFieldWrapper(
          child: FlightTrainLocationInput(
            label: l10n.form_labelFlightDeparture,
            // Hiển thị tên sân bay đã chọn hoặc gợi ý "Đi đâu?"
            hint: l10n.form_labelFlightWhereGo,
            value: "${state.criteria.departureAirport.desc ?? ""} (${state.criteria.departureCode})",
            icon: Icons.airplanemode_on_outlined,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
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
            value: "${state.criteria.destinationAirport.desc ?? ""} (${state.criteria.destinationCode})",
            icon: Icons.airplanemode_off_outlined,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
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
          child: FlightDatePickerSection(controller: controller, state: state,)
        ),

        // 6. Nhập thông tin hành khách & Hạng ghế
        FormFieldWrapper(
          child: PassengerInputField(
            adultCount: state.criteria.adultCount,
            childCount: state.criteria.childCount,
            infantCount: state.criteria.infantCount,
            onTap: () => _showPassengerModal(context, controller),
          ),
        ),

        SizedBox(height: context.rh(20.0)),

        // 7. Nút tìm kiếm
        SearchFlightButton(text: l10n.form_searchFlightButton),
      ],
    );
  }

  void _showPassengerModal(BuildContext context, FlightController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => PassengerSelectionFlightscreenModal(controller: controller),
    );
  }
}