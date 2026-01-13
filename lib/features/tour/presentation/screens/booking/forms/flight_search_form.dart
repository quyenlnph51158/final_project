import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../controller/travel_booking_controller.dart';
import '../input/date_field.dart';
import '../input/flight_train_location_input.dart';
import '../input/passenger_input_field.dart'; // Widget Passenger đã tách ở bước trước
import '../modals/showAirportOrStationList.dart';
import '../widgets/search_button.dart';
import '../widgets/trip_type_button.dart';     // Widget TripType đã tách ở bước trước
import '../modals/passenger_selection_modal.dart';
class FlightSearchForm extends StatelessWidget {
  const FlightSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Lắng nghe sự thay đổi từ controller
    final controller = context.read<TravelBookingController>();
    final state = context.watch<TravelBookingController>().state;

    return Column(
      children: [
        // 2. Chọn loại vé (Khứ hồi/Một chiều)
        Row(
          children: [
            TripTypeButton(
              text: l10n.form_tripRoundTrip,
              isSelected: state.isRoundTrip==true,
              onPressed: () => controller.updateTripType(true),
            ),
            const SizedBox(width: 10),
            TripTypeButton(
              text: l10n.form_tripOneWay,
              isSelected: state.isRoundTrip==false,
              onPressed: () => controller.updateTripType(false),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 3. Điểm khởi hành
        FlightTrainLocationInput(
          label: l10n.form_labelFlightDeparture,
          // Hiển thị tên sân bay đã chọn hoặc gợi ý "Đi đâu?"
          value: state.departure.isEmpty
              ? l10n.form_labelFlightWhereGo
              : state.departure,
          icon: Icons.airplanemode_on_outlined,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => ShowAirportOrStationList(
                isDeparture: true, // true cho điểm đi, false cho điểm đến
                icon: Icons.airplanemode_on_outlined,
                controller: controller, // Truyền controller hiện tại vào
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        // 4. Điểm đến
        FlightTrainLocationInput(
          label: l10n.form_labelFlightArrival,
          value: state.destination.isEmpty ? l10n.form_labelFlightWhereArrive : state.destination,
          icon: Icons.airplanemode_off_outlined,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => ShowAirportOrStationList(
                isDeparture: false, // true cho điểm đi, false cho điểm đến
                icon: Icons.airplanemode_off_outlined,
                controller: controller, // Truyền controller hiện tại vào
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // 5. Chọn ngày
        Row(
          children: [
            Expanded(
              child: DateField(
                label: l10n.form_labelDepartureDate,
                value: state.selectedDate,
                onTap: () => controller.selectDate(context, isReturnDate: false),
              ),
            ),
            if (state.isRoundTrip) ...[
              const SizedBox(width: 8),
              Expanded(
                child: DateField(
                  label: l10n.form_labelFlightReturnDate,
                  value: state.returnDate ?? '',
                  onTap: () => controller.selectDate(context, isReturnDate: true),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // 6. Nhập thông tin hành khách & Hạng ghế
        PassengerInputField(
          adultCount: state.adultCount,
          childCount: state.childCount,
          infantCount: state.infantCount,
          selectedClass: state.selectedClass,
          onTap: () => _showPassengerModal(context, controller),
        ),

        const SizedBox(height: 20),

        // 7. Nút tìm kiếm
        SearchButton(text: l10n.form_searchFlightButton),
      ],
    );
  }

  void _showPassengerModal(BuildContext context, TravelBookingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PassengerSelectionModal(controller: controller),
    );
  }
}