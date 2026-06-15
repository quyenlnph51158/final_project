import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart'; // Import extension mới

class PassengerSelectionFlightscreenModal extends StatefulWidget {
  final FlightController controller;

  const PassengerSelectionFlightscreenModal({
    super.key,
    required this.controller,
  });

  @override
  State<PassengerSelectionFlightscreenModal> createState() =>
      _PassengerSelectionFlightScreenModalState();
}

class _PassengerSelectionFlightScreenModalState
    extends State<PassengerSelectionFlightscreenModal> {
  late int tempAdultCount;
  late int tempChildCount;
  late int tempInfantCount;

  @override
  void initState() {
    super.initState();
    final state = widget.controller.state;
    tempAdultCount = state.criteria.adultCount;
    tempChildCount = state.criteria.childCount;
    tempInfantCount = state.criteria.infantCount;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const int maxTotalPassengers = 9; // Giới hạn chuẩn ngành hàng không
    final int currentTotalPassengers = tempAdultCount + tempChildCount;

    return Container(
      // Thay h(50) bằng rh(450) để chiều cao ổn định theo tỷ lệ pixel scale
      height: context.rh(450).clamp(400.0, 580.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius * 1.5),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, l10n),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: context.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  _buildCounter(
                    context,
                    title: l10n.form_labelAdult,
                    subtitle: l10n.form_labelAdultSubtitle,
                    currentValue: tempAdultCount,
                    minLimit: 1,
                    maxLimit: maxTotalPassengers,
                    canIncrement: currentTotalPassengers < maxTotalPassengers,
                    onUpdate: (val) => setState(() => tempAdultCount = val),
                  ),
                  _buildCounter(
                    context,
                    title: l10n.form_labelChild,
                    subtitle: l10n.form_labelChildSubtitle,
                    currentValue: tempChildCount,
                    minLimit: 0,
                    maxLimit: maxTotalPassengers,
                    canIncrement: currentTotalPassengers < maxTotalPassengers,
                    onUpdate: (val) => setState(() => tempChildCount = val),
                  ),
                  _buildCounter(
                    context,
                    title: l10n.form_labelInfant,
                    subtitle: l10n.form_labelInfantSubtitle,
                    currentValue: tempInfantCount,
                    minLimit: 0,
                    // Quy định: Số trẻ sơ sinh không vượt quá số người lớn
                    maxLimit: tempAdultCount,
                    canIncrement: tempInfantCount < tempAdultCount,
                    onUpdate: (val) => setState(() => tempInfantCount = val),
                  ),
                ],
              ),
            ),
          ),
          _buildConfirmButton(context, l10n),
        ],
      ),
    );
  }

  // --- Widget Header ---
  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.all(context.padding),
      child: Column(
        children: [
          Container(
            height: context.rh(4), // Thay 4 bằng rh(4)
            width: context.rw(40), // Thay w(10) bằng rw(40) cho handle bar
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(context.radius),
            ),
          ),
          SizedBox(height: context.rh(12)), // Thay h(1.5) bằng rh(12)
          Text(
            l10n.form_modalPassengerTitle,
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF263238),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Dòng tăng giảm số lượng ---
  Widget _buildCounter(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int currentValue,
    required int minLimit,
    required int maxLimit,
    required bool canIncrement,
    required Function(int) onUpdate,
  }) {
    return Padding(
      // Thay h(1.5) bằng rh(16) để khoảng cách dọc ổn định
      padding: EdgeInsets.symmetric(vertical: context.rh(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF263238),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: context.sp(12),
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: currentValue > minLimit
                      ? kPrimaryColor
                      : Colors.grey.shade300,
                  size: context.icon(28),
                ),
                onPressed: currentValue > minLimit
                    ? () => onUpdate(currentValue - 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Container(
                // Cố định chiều rộng cột số bằng rw thay cho w%
                constraints: BoxConstraints(minWidth: context.rw(35)),
                alignment: Alignment.center,
                child: Text(
                  currentValue.toString(),
                  style: TextStyle(
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: (canIncrement && currentValue < maxLimit)
                      ? kPrimaryColor
                      : Colors.grey.shade300,
                  size: context.icon(28),
                ),
                onPressed: (canIncrement && currentValue < maxLimit)
                    ? () => onUpdate(currentValue + 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget Nút Xác nhận ---
  Widget _buildConfirmButton(BuildContext context, AppLocalizations l10n) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(context.padding),
        child: SizedBox(
          width: double.infinity,
          // Chiều cao nút bấm chuẩn UX 48px (đã scale)
          height: context.rh(48).clamp(45.0, 55.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius),
              ),
            ),
            onPressed: () {
              widget.controller.updatePassengerData(
                adults: tempAdultCount,
                children: tempChildCount,
                infants: tempInfantCount,
              );
              Navigator.pop(context);
            },
            child: Text(
              l10n.form_confirmButton,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: context.sp(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
