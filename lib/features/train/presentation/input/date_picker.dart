import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:final_project/features/train/presentation/state/train_state.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../../core/utils/date_picker.dart';
import '../../../tour/presentation/booking/input/date_field.dart';

class TrainDatePickerSection extends StatelessWidget {
  final TrainController controller;
  final TrainState state;

  const TrainDatePickerSection({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // 1. Ô chọn ngày đi (Luôn hiển thị)
        Expanded(
          child: DateField(
            label: l10n.form_labelDepartureDate,
            hintText: l10n.form_defaultReturnDate,
            value: state.form.DepartureDate,
            onTap: () => _handleDatePicking(context, isReturn: false),
          ),
        ),

        // 2. Ô chọn ngày về (Chỉ hiện khi là Khứ hồi)
        if (state.form.isRoundTrip) ...[
          // Thay w(3) bằng rw(12) để khoảng cách ổn định trên mọi màn hình thực tế
          SizedBox(width: context.rw(12)),
          Expanded(
            child: DateField(
              label: l10n.form_labelFlightReturnDate,
              hintText: l10n.form_defaultReturnDate,
              value: state.form.ReturnDate ?? '',
              onTap: () => _handleDatePicking(context, isReturn: true),
            ),
          ),
        ],
      ],
    );
  }

  /// Logic xử lý chọn ngày
  void _handleDatePicking(BuildContext context, {required bool isReturn}) {
    DatePicker.pickDate(
      context: context,
      onDateSelected: (formattedDate, originalDate) {
        // Cập nhật ngày đã chọn vào controller
        controller.setDate(returnDate: isReturn, dateTime: formattedDate);

        // UX: Nếu vừa chọn ngày đi trong chế độ khứ hồi, tự động mở picker chọn ngày về
        if (!isReturn && state.form.isRoundTrip) {
          // Tăng delay nhẹ để máy thật xử lý đóng/mở dialog mượt mà hơn
          Future.delayed(const Duration(milliseconds: 350), () {
            if (context.mounted) {
              DatePicker.pickDate(
                context: context,
                initialDate: originalDate,
                onDateSelected: (formattedReturn, _) {
                  controller.setDate(
                    returnDate: true,
                    dateTime: formattedReturn,
                  );
                },
              );
            }
          });
        }
      },
    );
  }
}
