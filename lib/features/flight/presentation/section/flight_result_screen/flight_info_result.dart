import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
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
      padding: EdgeInsets.all(context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. PHẦN MÃ SÂN BAY VÀ ICON MÁY BAY
          _buildAirportRoute(context, criteria.departureCode, criteria.destinationCode, criteria.roundTrip),

          SizedBox(height: context.rw(8.0)),

          // 2. TÊN THÀNH PHỐ
          _buildCityNames(context, criteria.departureAirport.desc ?? '', criteria.destinationAirport.desc ?? ''),

          SizedBox(height: context.rw(16.0)),

          // 3. THÔNG TIN KHỞI HÀNH & TRỞ VỀ
          Row(
            children: [
              Expanded(child: _buildInfoItem(context, l10n.form_labelDepartureDate, criteria.departureDate ?? '')),
              if (criteria.roundTrip)
                Expanded(child: _buildInfoItem(context, l10n.form_labelFlightReturnDate, criteria.returnDate ?? '')),
            ],
          ),

          SizedBox(height: context.rw(16.0)),

          // 4. THÔNG TIN HÀNH KHÁCH
          _buildInfoItem(context, l10n.general_passengerLabel, _getPassengerText(criteria, l10n)),

          SizedBox(height: context.rh(12.0)),

          // 5. NÚT THAY ĐỔI
          _buildChangeButton(context, l10n),

          const SizedBox(height: 16),
          const Divider(height: 1.0, color: Color(0xFFE4E7E9)),
        ],
      ),
    );
  }

  Widget _buildAirportRoute(BuildContext context, String from, String to, bool isRoundTrip) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(from, style: TextStyle(
          color: const Color(0xFF01171B),
          fontSize: context.sp(20),
          fontWeight: FontWeight.w700,
        )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildFlightLine(context, isForward: true),
                if (isRoundTrip) ...[
                  SizedBox(height: context.rh(6.0)),
                  _buildFlightLine(context, isForward: false),
                ]
              ],
            ),
          ),
        ),
        Text(to, style: TextStyle(
          color: const Color(0xFF01171B),
          fontSize: context.sp(20),
          fontWeight: FontWeight.w700,
        )),
      ],
    );
  }

  Widget _buildFlightLine(BuildContext context ,{required bool isForward}) {
    return Row(
      children: [
        if (!isForward) _flightIcon(context, quarterTurns: 3),
        Expanded(
          child: DottedLine(
            dashLength: context.rw(6),
            dashGapLength: context.rw(4),
            lineThickness: context.rh(1),
            dashColor: kPrimaryColor, // Sử dụng màu thương hiệu thay vì teal cứng
          ),
        ),
        if (isForward) ...[
          SizedBox(width: context.rw(6.0)),
          _flightIcon(context, quarterTurns: 1),
        ]
      ],
    );
  }

  Widget _flightIcon(BuildContext context, {required int quarterTurns}) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Icon(Icons.flight, color: kPrimaryColor, size: context.icon(18)),
    );
  }

  Widget _buildCityNames(BuildContext context, String from, String to) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(from, style: TextStyle(
          color: const Color(0xFF555F65),
          fontSize: context.sp(12),
          fontWeight: FontWeight.w400,
        )),
        Text(to, style: TextStyle(
          color: const Color(0xFF555F65),
          fontSize: context.sp(12),
          fontWeight: FontWeight.w400,
        )),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: const Color(0xFF01171B),
          fontSize: context.sp(12),
          fontWeight: FontWeight.w600,
        )),
        SizedBox(height: context.rh(4.0)),
        Text(value, style: TextStyle(
          color: const Color(0xFF01171B),
          fontSize: context.sp(16),
          fontWeight: FontWeight.w600,
        )),
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
      child: Text(l10n.text_change_btn, style: TextStyle(
        color: kPrimaryColor,
        fontSize: context.sp(14),
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      )),
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