import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';

class PassengerSelectionFlightscreenModal extends StatefulWidget {
  final FlightController controller;

  const PassengerSelectionFlightscreenModal({super.key, required this.controller});

  @override
  State<PassengerSelectionFlightscreenModal> createState() => _PassengerSelectionFLightScreenModalState();
}

class _PassengerSelectionFLightScreenModalState extends State<PassengerSelectionFlightscreenModal> {
  // Khởi tạo các biến tạm thời từ state hiện tại của controller
  late int tempAdultCount;
  late int tempChildCount;
  late int tempInfantCount;

  @override
  void initState() {
    super.initState();
    final state = widget.controller.state;
    tempAdultCount = state.adultCount;
    tempChildCount = state.childCount;
    tempInfantCount = state.infantCount;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final int maxTotalPassengers = 9;
    final int currentTotalPassengers = tempAdultCount + tempChildCount;

    final List<String> classes = [
      l10n.form_defaultClass,
      l10n.form_classPremiumEconomy,
      l10n.form_classBusiness,
      l10n.form_classFirst
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          _buildHeader(l10n),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.5))),
          const SizedBox(height: 10),
          Text(l10n.form_modalPassengerTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
          Row(children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: kPrimaryColor),
              onPressed: currentValue > minLimit ? () => onUpdate(currentValue - 1) : null,
            ),
            Text(currentValue.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: kPrimaryColor),
              onPressed: canIncrement && currentValue < maxLimit ? () => onUpdate(currentValue + 1) : null,
            ),
          ]),
        ],
      ),
    );
  }


  Widget _buildConfirmButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            // Cập nhật dữ liệu vào controller thông qua hàm copyWith
            widget.controller.updatePassengerData(
              adults: tempAdultCount,
              children: tempChildCount,
              infants: tempInfantCount,
            );
            Navigator.pop(context);
          },
          child: Text(l10n.form_confirmButton, style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}