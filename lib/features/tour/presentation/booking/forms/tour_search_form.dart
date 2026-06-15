import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/date_picker.dart';
import '../../../../../core/utils/responsive_layout.dart'; // Import extension mới
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

    // Optimization: Chỉ lắng nghe những giá trị thay đổi cụ thể
    final destination = context.select(
      (TravelBookingController c) => c.state.form.tempDestination,
    );
    final selectedDate = context.select(
      (TravelBookingController c) => c.state.form.selectedDate,
    );

    final controller = context.read<TravelBookingController>();

    // Cố định khoảng cách giữa các field theo tỷ lệ pixel thiết kế (khoảng 12px)
    final double fieldGap = context.rh(12);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Khoảng cách phía trên cùng của Form (Thay h(2) bằng rh(16))
        SizedBox(height: context.rh(16)),

        // 1. Chọn điểm đến
        FormFieldWrapper(
          child: LocationSelectionField(
            label: l10n.form_defaultDestination,
            currentValue: destination,
          ),
        ),

        SizedBox(height: fieldGap),

        // 2. Chọn ngày khởi hành
        FormFieldWrapper(
          child: DateField(
            label: l10n.form_labelDepartureDate,
            hintText: '',
            value: selectedDate,
            onTap: () => DatePicker.pickDate(
              context: context,
              onDateSelected: (formattedDate, originalDate) {
                controller.setDepartureDate(formattedDate);
              },
            ),
          ),
        ),

        SizedBox(height: fieldGap),

        // 3. Nhập nơi khởi hành
        FormFieldWrapper(
          child: InputField(
            label: l10n.form_labelDeparturePlace,
            hint: l10n.form_defaultDeparture,
            controller: controller.departureController,
            onChanged: (value) => controller.updateDeparture(value),
          ),
        ),

        // Khoảng cách đến Nút Search (Thay h(2.5) bằng rh(24) để nổi bật nút bấm)
        SizedBox(height: context.rh(24)),

        // 4. Nút tìm kiếm
        SearchButton(text: l10n.form_searchTourButton, onPressed: onSearch),

        // Padding dưới cùng (Thay h(1) bằng rh(12))
        SizedBox(height: context.rh(12)),
      ],
    );
  }
}
