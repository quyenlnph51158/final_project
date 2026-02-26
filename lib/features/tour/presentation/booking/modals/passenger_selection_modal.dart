import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_dividers.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/shared/widgets/drag_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../controller/travel_booking_controller.dart';

class PassengerSelectionModal extends StatefulWidget {
  final TravelBookingController controller;

  const PassengerSelectionModal({super.key, required this.controller});

  @override
  State<PassengerSelectionModal> createState() => _PassengerSelectionModalState();
}

class _PassengerSelectionModalState extends State<PassengerSelectionModal> {
  // Khởi tạo các biến tạm thời từ state hiện tại của controller
  late int tempAdultCount;
  late int tempChildCount;
  late int tempInfantCount;

  @override
  void initState() {
    super.initState();
    final state = widget.controller.state;
    tempAdultCount = state.form.adultCount;
    tempChildCount = state.form.childCount;
    tempInfantCount = state.form.infantCount;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final int maxTotalPassengers = 9;
    final int currentTotalPassengers = tempAdultCount + tempChildCount;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          _buildHeader(l10n),
          Expanded(
            child: Padding(
              padding: AppLayoutSpacing.paddingContentSelectionPassenger,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDividers.labelAndContent,
                  _buildCounter(
                    title: l10n.form_labelAdult,
                    subtitle: l10n.form_labelAdultSubtitle,
                    currentValue: tempAdultCount,
                    minLimit: 1,
                    maxLimit: maxTotalPassengers,
                    canIncrement: currentTotalPassengers < maxTotalPassengers,
                    onUpdate: (val) => setState(() => tempAdultCount = val),
                  ),
                  _buildCounter(
                    title: l10n.form_labelChild,
                    subtitle: l10n.form_labelChildSubtitle,
                    currentValue: tempChildCount,
                    minLimit: 0,
                    maxLimit: maxTotalPassengers,
                    canIncrement: currentTotalPassengers < maxTotalPassengers,
                    onUpdate: (val) => setState(() => tempChildCount = val),
                  ),
                  _buildCounter(
                    title: l10n.form_labelInfant,
                    subtitle: l10n.form_labelInfantSubtitle,
                    currentValue: tempInfantCount,
                    minLimit: 0,
                    maxLimit: tempAdultCount,
                    canIncrement: tempInfantCount < tempAdultCount,
                    onUpdate: (val) => setState(() => tempInfantCount = val),
                  ),
                ],
              ),
            ),
          ),
          _buildConfirmButton(l10n),
        ],
      ),
    );
  }

  // --- Các Widget thành phần ---

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: AppLayoutSpacing.paddingHeaderSelectionPassenger,
      child: Column(
        children: [
          const DragIndicator(),
          AppLayoutSpacing.handleAndTitle,
          Text(l10n.form_modalPassengerTitle, style: AppStyles.titleShowList),
        ],
      ),
    );
  }

  Widget _buildCounter({
    required String title,
    required String subtitle,
    required int currentValue,
    required int minLimit,
    required int maxLimit,
    required bool canIncrement,
    required Function(int) onUpdate,
  }) {
    return Padding(
      padding: AppLayoutSpacing.paddingContentCounterPassenger,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppStyles.titleCounter),
            Text(subtitle, style: AppStyles.subtitleCounter),
          ]),
          Row(children: [
            IconButton(
              icon: AppIcons.iconRemoveCounter,
              onPressed: currentValue > minLimit ? () => onUpdate(currentValue - 1) : null,
            ),
            Text(currentValue.toString(), style: AppStyles.valueCounter),
            IconButton(
              icon: AppIcons.iconAddCounter,
              onPressed: canIncrement && currentValue < maxLimit ? () => onUpdate(currentValue + 1) : null,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(AppLocalizations l10n) {
    return Padding(
      padding: AppLayoutSpacing.paddingConfirmPassengerButton,
      child: SizedBox(
        width: double.infinity,
        height: AppSizes.searchButton,
        child: ElevatedButton(
          style: AppStyles.searchButton,
          onPressed: () {
            // Cập nhật dữ liệu vào controller thông qua hàm copyWith
            widget.controller.updatePassengerData(
              adults: tempAdultCount,
              children: tempChildCount,
              infants: tempInfantCount,
            );
            Navigator.pop(context);
          },
          child: Text(l10n.form_confirmButton, style: AppStyles.textSubmitButton),
        ),
      ),
    );
  }

}