import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/design/flight/flight_divider.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../controller/flight_controller.dart';
import '../../screens/flight_screen.dart';

class FlightInfoResult extends StatelessWidget {
  const FlightInfoResult({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<FlightController>().state;
    final criteria = state.criteria;

    return Padding(
      padding: EdgeInsets.all(FlightLayoutSpacing.paddingAll(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. PHẦN MÃ SÂN BAY VÀ ICON MÁY BAY
          _buildAirportRoute(context, criteria.departureCode, criteria.destinationCode, criteria.roundTrip),

          SizedBox(height: FlightLayoutSpacing.gapSmall(context)),

          // 2. TÊN THÀNH PHỐ
          _buildCityNames(context, criteria.departure, criteria.destination),

          SizedBox(height: FlightLayoutSpacing.gapMedium(context)),

          // 3. THÔNG TIN KHỞI HÀNH & TRỞ VỀ
          Row(
            children: [
              Expanded(child: _buildInfoItem(context, l10n.form_labelDepartureDate, criteria.departureDate ?? '')),
              if (criteria.roundTrip)
                Expanded(child: _buildInfoItem(context, l10n.form_labelFlightReturnDate, criteria.returnDate ?? '')),
            ],
          ),

          SizedBox(height: FlightLayoutSpacing.gapMedium(context)),

          // 4. THÔNG TIN HÀNH KHÁCH
          _buildInfoItem(context, l10n.general_passengerLabel, _getPassengerText(criteria, l10n)),

          SizedBox(height: FlightLayoutSpacing.gapChangeBtn(context)),

          // 5. NÚT THAY ĐỔI
          _buildChangeButton(context, l10n),

          const SizedBox(height: 16),
          const Divider(height: FlightDivider.dashThickness, color: Color(0xFFE4E7E9)),
        ],
      ),
    );
  }

  Widget _buildAirportRoute(BuildContext context, String from, String to, bool isRoundTrip) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(from, style: FlightStyle.codeHighlight(context)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildFlightLine(context, isForward: true),
                if (isRoundTrip) ...[
                  SizedBox(height: FlightLayoutSpacing.gapLineVertical(context)),
                  _buildFlightLine(context, isForward: false),
                ]
              ],
            ),
          ),
        ),
        Text(to, style: FlightStyle.codeHighlight(context)),
      ],
    );
  }

  Widget _buildFlightLine(BuildContext context ,{required bool isForward}) {
    return Row(
      children: [
        if (!isForward) _flightIcon(context, quarterTurns: 3),
        Expanded(
          child: DottedLine(
            dashLength: FlightSize.dashLength(context),
            dashGapLength: FlightSize.dashGap(context),
            lineThickness: FlightSize.dividerThin(context),
            dashColor: kPrimaryColor, // Sử dụng màu thương hiệu thay vì teal cứng
          ),
        ),
        if (isForward) ...[
          SizedBox(width: FlightLayoutSpacing.gapIconText(context)),
          _flightIcon(context, quarterTurns: 1),
        ]
      ],
    );
  }

  Widget _flightIcon(BuildContext context, {required int quarterTurns}) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Icon(Icons.flight, color: kPrimaryColor, size: FlightSize.iconFlightSmall(context)),
    );
  }

  Widget _buildCityNames(BuildContext context, String from, String to) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(from, style: FlightStyle.labelSmallGrey(context)),
        Text(to, style: FlightStyle.labelSmallGrey(context)),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FlightStyle.infoLabel(context)),
        SizedBox(height: FlightLayoutSpacing.gapInfoLabel(context)),
        Text(value, style: FlightStyle.infoValue(context)),
      ],
    );
  }

  Widget _buildChangeButton(BuildContext context, AppLocalizations l10n) {
    return InkWell(
      onTap: () {
        context.read<FlightController>().backToSearch();
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FlightScreen()),
        );
      },
      child: Text(l10n.text_change_btn, style: FlightStyle.linkButton(context)),
    );
  }

  String _getPassengerText(dynamic criteria, AppLocalizations l10n) {
    List<String> parts = [];
    if (criteria.adultCount > 0) parts.add('${criteria.adultCount} ${l10n.form_labelAdult}');
    if (criteria.childCount > 0) parts.add('${criteria.childCount} ${l10n.form_labelChild}');
    if (criteria.infantCount > 0) parts.add('${criteria.infantCount} ${l10n.form_labelInfant}');
    return parts.join(', ');
  }
}