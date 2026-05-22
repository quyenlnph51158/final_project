import 'package:dotted_line/dotted_line.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:final_project/features/train/presentation/screens/train_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';

class HeaderTrainResult extends StatelessWidget {
  const HeaderTrainResult({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TrainController>().state;
    final form = state.form;

    return Container(
      color: Colors.white,
      // Sử dụng lề chuẩn của hệ thống (12 hoặc 16 đã qua rw)
      padding: EdgeInsets.all(context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. MÃ GA VÀ ICON TÀU
          _buildTrainRoute(
            context,
            form.DepartureCode,
            form.DestinationCode,
            form.isRoundTrip,
          ),

          // Thay h(0.5) bằng rh(4) để khoảng cách ổn định trên máy thật
          SizedBox(height: context.rh(4)),

          // 2. TÊN THÀNH PHỐ
          _buildCityNames(context, form.Departure, form.Destination),

          // Thay h(2) bằng rh(16)
          SizedBox(height: context.rh(16)),

          // 3. THÔNG TIN KHỞI HÀNH & TRỞ VỀ
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  l10n.form_labelDepartureDate,
                  form.DepartureDate,
                ),
              ),
              if (form.isRoundTrip)
                Expanded(
                  child: _buildInfoItem(
                    context,
                    l10n.form_labelFlightReturnDate,
                    form.ReturnDate,
                  ),
                ),
            ],
          ),

          // Thay h(1.5) bằng rh(12)
          SizedBox(height: context.rh(12)),

          // 4. THÔNG TIN HÀNH KHÁCH
          _buildInfoItem(
            context,
            l10n.general_passengerLabel,
            _getPassengerText(form, l10n),
          ),

          // Thay h(2) bằng rh(16)
          SizedBox(height: context.rh(16)),

          // 5. NÚT THAY ĐỔI
          _buildChangeButton(context, l10n),

          SizedBox(height: context.rh(12)),
          const Divider(height: 1, color: Color(0xFFE4E7E9)),
        ],
      ),
    );
  }

  Widget _buildTrainRoute(
    BuildContext context,
    String from,
    String to,
    bool isRoundTrip,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          from,
          style: TextStyle(
            fontSize: context.sp(
              22,
            ), // Giảm nhẹ 24 -> 22 để an toàn trên máy nhỏ
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        Expanded(
          child: Padding(
            // Thay w(4) bằng rw(16)
            padding: EdgeInsets.symmetric(horizontal: context.rw(16)),
            child: Column(
              children: [
                _buildTrainLine(context, isForward: true),
                if (isRoundTrip) ...[
                  // Thay h(0.5) bằng rh(4)
                  SizedBox(height: context.rh(4)),
                  _buildTrainLine(context, isForward: false),
                ],
              ],
            ),
          ),
        ),
        Text(
          to,
          style: TextStyle(
            fontSize: context.sp(22),
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainLine(BuildContext context, {required bool isForward}) {
    return Row(
      children: [
        if (!isForward) _trainIcon(context),
        Expanded(
          child: DottedLine(
            dashLength: context.rw(4), // Dash cũng nên scale nhẹ
            dashGapLength: context.rw(4),
            lineThickness: context.rh(1.5),
            dashColor: kPrimaryColor.withOpacity(0.5),
          ),
        ),
        if (isForward) _trainIcon(context),
      ],
    );
  }

  Widget _trainIcon(BuildContext context) {
    return Padding(
      // Thay w(1) bằng rw(4)
      padding: EdgeInsets.symmetric(horizontal: context.rw(4)),
      child: Icon(Icons.train, color: kPrimaryColor, size: context.icon(18)),
    );
  }

  Widget _buildCityNames(BuildContext context, String from, String to) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          from,
          style: TextStyle(
            fontSize: context.sp(13),
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          to,
          style: TextStyle(
            fontSize: context.sp(13),
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.sp(12),
            color: Colors.grey.shade600,
          ),
        ),
        // Thay h(0.3) bằng rh(2)
        SizedBox(height: context.rh(2)),
        Text(
          value,
          style: TextStyle(
            fontSize: context.sp(15),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF263238),
          ),
        ),
      ],
    );
  }

  Widget _buildChangeButton(BuildContext context, AppLocalizations l10n) {
    return InkWell(
      onTap: () {
        context.read<TrainController>().backToSearch();
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TrainScreen()),
        );
      },
      child: Container(
        // Thay h(0.5) bằng rh(4)
        padding: EdgeInsets.symmetric(vertical: context.rh(4)),
        child: Text(
          l10n.text_change_btn,
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: context.sp(14),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  String _getPassengerText(dynamic criteria, AppLocalizations l10n) {
    List<String> parts = [];
    if (criteria.adultCount > 0)
      parts.add('${criteria.adultCount} ${l10n.form_labelAdult}');
    if (criteria.childCount > 0)
      parts.add('${criteria.childCount} ${l10n.form_labelChild}');
    if (criteria.infantCount > 0)
      parts.add('${criteria.infantCount} ${l10n.form_labelInfant}');
    return parts.join(', ');
  }
}
