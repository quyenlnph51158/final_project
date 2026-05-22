import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:final_project/features/train/presentation/input/date_picker.dart';
import 'package:final_project/features/train/presentation/modals/passenger_selection_trainScreen_modal.dart';
import 'package:final_project/features/train/presentation/modals/show_city_list.dart';
import 'package:final_project/features/train/presentation/widgets/search_train_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../shared/widgets/form_field_wrapper.dart';
import '../../../flight/presentation/inputs/passenger_input_field.dart';
import '../../../tour/presentation/booking/input/flight_train_location_input.dart';
import '../../../tour/presentation/booking/widgets/trip_type_button.dart';

class TrainForm extends StatelessWidget {
  const TrainForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<TrainController>();
    final state = context.watch<TrainController>().state;

    // Thay đổi từ h(1.5) sang rh(12) để khoảng cách dọc ổn định theo pixel scale
    final double fieldGap = context.rh(12);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. CHỌN LOẠI VÉ (KHỨ HỒI / MỘT CHIỀU)
        Row(
          children: [
            TripTypeButton(
              text: l10n.form_tripRoundTrip,
              isSelected: state.form.isRoundTrip == true,
              onPressed: () => controller.updateTripType(true),
            ),
            // Thay w(3) bằng rw(12) để khoảng cách ngang không bị dãn quá rộng trên máy to
            SizedBox(width: context.rw(12)),
            TripTypeButton(
              text: l10n.form_tripOneWay,
              isSelected: state.form.isRoundTrip == false,
              onPressed: () => controller.updateTripType(false),
            ),
          ],
        ),

        SizedBox(height: fieldGap),

        // 2. ĐIỂM KHỞI HÀNH
        FormFieldWrapper(
          child: FlightTrainLocationInput(
            label: l10n.form_labelFlightDeparture,
            hint: l10n.form_labelFlightWhereGo,
            value: "${state.form.Departure} (${state.form.DepartureCode})",
            icon: Icons.train_outlined,
            onTap: () => _showCityModal(context, controller, true),
          ),
        ),

        SizedBox(height: fieldGap),

        // 3. ĐIỂM ĐẾN
        FormFieldWrapper(
          child: FlightTrainLocationInput(
            label: l10n.form_labelFlightArrival,
            hint: l10n.form_labelFlightWhereArrive,
            value: "${state.form.Destination} (${state.form.DestinationCode})",
            icon: Icons.train_outlined,
            onTap: () => _showCityModal(context, controller, false),
          ),
        ),

        SizedBox(height: fieldGap),

        // 4. CHỌN NGÀY
        FormFieldWrapper(
          child: TrainDatePickerSection(controller: controller, state: state),
        ),

        SizedBox(height: fieldGap),

        // 5. NHẬP THÔNG TIN HÀNH KHÁCH
        FormFieldWrapper(
          child: PassengerInputField(
            adultCount: state.form.adultCount,
            childCount: state.form.childCount,
            infantCount: state.form.infantCount,
            onTap: () => _showPassengerModal(context, controller),
          ),
        ),

        // Thay h(3) bằng rh(24) để khoảng cách đến nút search cân đối
        SizedBox(height: context.rh(24)),

        // 6. NÚT TÌM KIẾM
        SearchTrainButton(text: l10n.form_searchTrainButton),
      ],
    );
  }

  // --- Modal logic giữ nguyên vì các Modal con đã được tối ưu nội dung ---
  void _showCityModal(
    BuildContext context,
    TrainController controller,
    bool isDeparture,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShowCityList(
        isDeparture: isDeparture,
        icon: Icons.train_rounded,
        controller: controller,
      ),
    );
  }

  void _showPassengerModal(BuildContext context, TrainController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          PassengerSelectionTrainscreenModal(controller: controller),
    );
  }
}
