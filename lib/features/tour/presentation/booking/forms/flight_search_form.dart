import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/utils/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../shared/widgets/form_field_wrapper.dart';
import '../../controller/travel_booking_controller.dart';
import '../input/date_field.dart';
import '../input/flight_train_location_input.dart';
import '../input/passenger_input_field.dart'; // Widget Passenger đã tách ở bước trước
import '../modals/showAirportOrStationList.dart';
import '../widgets/search_button.dart';
import '../widgets/trip_type_button.dart';     // Widget TripType đã tách ở bước trước
import '../modals/passenger_selection_modal.dart';
class FlightSearchForm extends StatelessWidget {
  final VoidCallback onSearch;
  const FlightSearchForm({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Lắng nghe sự thay đổi từ controller
    final controller = context.read<TravelBookingController>();
    final state = context.watch<TravelBookingController>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 2. Chọn loại vé (Khứ hồi/Một chiều)
        Row(
          children: [
            TripTypeButton(
              text: l10n.form_tripRoundTrip,
              isSelected: state.form.isRoundTrip==true,
              onPressed: () => controller.updateTripType(true),
            ),
            const SizedBox(width: 10),
            TripTypeButton(
              text: l10n.form_tripOneWay,
              isSelected: state.form.isRoundTrip==false,
              onPressed: () => controller.updateTripType(false),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 3. Điểm khởi hành
        FormFieldWrapper(
          child: FlightTrainLocationInput(
            label: l10n.form_labelFlightDeparture,
            hint: l10n.form_labelFlightWhereGo,
            // Hiển thị tên sân bay đã chọn hoặc gợi ý "Đi đâu?"
            value: state.form.departure,
            icon: Icons.airplanemode_on_outlined,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: kBackgroundColor,
                shape: AppShape.selectionField,
                builder: (context) => ShowAirportOrStationList(
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
            value: state.form.destination,
            icon: Icons.airplanemode_off_outlined,
            onTap: () {
              showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: kBackgroundColor,
              shape: AppShape.selectionField,
              builder: (context) => ShowAirportOrStationList(
                isDeparture: false, // true cho điểm đi, false cho điểm đến
                icon: Icons.airplanemode_off_outlined,
                controller: controller, // Truyền controller hiện tại vào
              ),);
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
                    value: state.form.selectedDate,
                    onTap: () async {
                      final picked = await DatePicker.pickDate(context);
                      if(picked !=null ) {
                        controller.setDate(picked,isReturnDate: false );
                      }
                    }
                  ),
                ),
                if (state.form.isRoundTrip) ...[
                  const SizedBox(width: 5),
                  Expanded(
                    child: DateField(
                      label: l10n.form_labelFlightReturnDate,
                      hintText: l10n.form_defaultReturnDate,
                      value: state.form.returnDate.toString() ,
                      onTap: () async{
                        final picked = await DatePicker.pickDate(context);
                        if(picked != null){
                          controller.setDate(picked, isReturnDate: true);
                        }
                      }
                    ),
                  ),
                ],
              ],
            ),
        ),
        // 6. Nhập thông tin hành khách & Hạng ghế
        FormFieldWrapper(
            child: PassengerInputField(
              adultCount: state.form.adultCount,
              childCount: state.form.childCount,
              infantCount: state.form.infantCount,
              onTap: () => _showPassengerModal(context, controller),
            ),
        ),

        AppLayoutSpacing.fieldAndButton,

        // 7. Nút tìm kiếm
        SearchButton(
          text: l10n.form_searchFlightButton,
          onPressed: onSearch,
        ),
      ],
    );
  }

  void _showPassengerModal(BuildContext context, TravelBookingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: AppShape.selectList,
      builder: (context) => PassengerSelectionModal(controller: controller),
    );
  }
}
