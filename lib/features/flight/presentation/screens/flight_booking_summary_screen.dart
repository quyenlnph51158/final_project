import 'package:final_project/app/controller/payment_controller.dart';
import 'package:final_project/features/flight/data/models/flight_detail.dart';
import 'package:final_project/features/flight/data/models/response/flight_create_booking_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../core/utils/format_price.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../controller/flight_controller.dart';

class FlightBookingSummaryScreen extends StatefulWidget {
  const FlightBookingSummaryScreen({super.key});

  @override
  State<FlightBookingSummaryScreen> createState() =>
      _FlightBookingSummaryScreenState();
}

class _FlightBookingSummaryScreenState
    extends State<FlightBookingSummaryScreen> {
  bool _isTermsAccepted = false;
  int _selectedPaymentMethod = 1; // 1: Card, 2: Apple Pay

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<FlightController>().state;
    final booking = state.data.bookingSummary?.data?.booking;
    final paymentController = context.watch<PaymentController>();
    final flightInfo = booking?.bookingInfo?.flight?.flightInfo;
    final fareGo = flightInfo?.flightGoFareClassSelected?.totalFare ?? 0;
    final fareReturn =
        flightInfo?.flightReturnFareClassSelected?.totalFare ?? 0;
    final totalFare = fareGo + fareReturn;

    final chargeGo = flightInfo?.flightGoFareClassSelected?.totalCharge ?? 0;
    final chargeReturn =
        flightInfo?.flightReturnFareClassSelected?.totalCharge ?? 0;
    final totalCharge = chargeGo + chargeReturn;

    final totalAmount = booking?.amount ?? 0;
    final currency = booking?.currency ?? "VND";
    final serviceFee = totalAmount - totalFare - totalCharge;
    // Trường hợp đang tải hoặc không có dữ liệu
    if (booking == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      );
    }

    // TRẢ VỀ COLUMN (KHÔNG dùng SliverToBoxAdapter, không dùng Expanded/SingleChildScrollView ở đây)
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(context.padding),
          child: Column(
            children: [
              // 1. THÔNG TIN ĐẶT VÉ
              _buildSectionCard(
                title: l10n.flight_summary_booking_info,
                children: [
                  _buildDetailRow(
                    l10n.flight_summary_booking_code,
                    booking.bookingCode ?? "",
                    isBoldValue: true,
                  ),
                  _buildDetailRow(
                    l10n.flight_summary_payment_deadline,
                    "${FormatDate.formatDate(booking.paymentExpiredAt)}\n${l10n.flight_summary_payment_note}",
                    isMultiLine: true,
                  ),
                ],
              ),

              // 2. THÔNG TIN KHÁCH HÀNG & GIÁ
              _buildSectionCard(
                title: l10n.flight_summary_customer_info,
                children: [
                  _buildDetailRow(
                    l10n.flight_summary_fullname,
                    booking.customer?.fullName ?? "",
                  ),
                  _buildDetailRow(
                    l10n.flight_summary_phone,
                    booking.customer?.phoneOriginal ?? "",
                  ),
                  _buildDetailRow(
                    l10n.flight_summary_booking_date,
                    DateFormat(
                      "HH:mm dd 'Th'M, yyyy",
                    ).format(DateTime.parse(booking.createdAt ?? '')),
                  ),
                  _buildDetailRow(
                    l10n.flight_summary_email,
                    booking.customerEmail ?? "",
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.flight_summary_total,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.sp(16),
                        ),
                      ),
                      Text(
                        "${FormatPrice.formatPrice(booking.amount ?? 0)} ${currency}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.sp(18),
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.rh(8)),
                  _buildDetailRow(
                    l10n.flight_summary_base_fare,
                    "${FormatPrice.formatPrice(totalFare)} ${currency}",
                  ),
                  _buildDetailRow(
                    l10n.flight_summary_tax_charge,
                    "${FormatPrice.formatPrice(totalCharge)} ${currency}",
                  ),
                  _buildDetailRow(
                    l10n.flight_summary_service_fee,
                    "${FormatPrice.formatPrice(serviceFee)} ${currency}",
                  ),
                ],
              ),

              // 3. HÀNH TRÌNH
              _buildSectionCard(
                title: l10n.flight_summary_itinerary,
                trailing: Text(
                  l10n.flight_summary_itinerary_detail,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: context.sp(12),
                  ),
                ),
                children: [
                  if (booking
                          .bookingInfo
                          ?.flight
                          ?.flightInfo
                          ?.flightSelected
                          ?.go !=
                      null)
                    _buildFlightRoute(
                      l10n,
                      booking
                          .bookingInfo!
                          .flight!
                          .flightInfo!
                          .flightSelected!
                          .go!,
                      state.data.selectedOutboundFlight,
                      l10n.flight_summary_departure,
                    ),
                  if (booking
                          .bookingInfo
                          ?.flight
                          ?.flightInfo
                          ?.flightSelected
                          ?.returnFlight !=
                      null)
                    _buildFlightRoute(
                      l10n,
                      booking
                          .bookingInfo!
                          .flight!
                          .flightInfo!
                          .flightSelected!
                          .returnFlight!,
                      state.data.selectedReturnFlight,
                      l10n.flight_summary_return,
                    ),
                ],
              ),

              // 4. THÔNG TIN HÀNH KHÁCH
              _buildSectionCard(
                title: l10n.flight_summary_passenger_info,
                children: (booking.bookingInfo?.flight?.passengers ?? [])
                    .map((p) => _buildPassengerInfo(p, l10n))
                    .toList(),
              ),

              // 5. PHƯƠNG THỨC THANH TOÁN
              _buildSectionCard(
                title: l10n.flight_summary_payment_method,
                children: [
                  _buildPaymentOption(
                    1,
                    l10n.flight_summary_card_method,
                    'assets/icons/icon_creditcard_debitcard.png',
                  ),
                  _buildPaymentOption(
                    2,
                    l10n.flight_summary_apple_pay,
                    "assets/icons/icon_applepay.png",
                  ),
                ],
              ),
            ],
          ),
        ),

        // BOTTOM BUTTON (Nút thanh toán luôn nằm dưới cùng của danh sách)
        _buildBottomAction(context, paymentController.isLoading, () {
          if (_selectedPaymentMethod == 1) {
            context.read<PaymentController>().startPaymentFlow(
              context,
              state.data.bookingSummary?.data?.bookingSid ?? '',
            );
          } else{
            _showUnsupportedAlert(context);
          }
        }, l10n),
        SizedBox(height: context.rh(20)),
      ],
    );
  }

  // --- WIDGET HELPERS (Giữ nguyên logic nhưng tối ưu UI Box) ---

  Widget _buildSectionCard({
    required String title,
    Widget? trailing,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: context.rh(16)),
      padding: EdgeInsets.all(context.rw(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(15),
                ),
              ),
              // if (trailing != null) trailing,
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBoldValue = false,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(8)),
      child: Row(
        crossAxisAlignment: isMultiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.rw(110),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: context.sp(13),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
                fontSize: context.sp(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightRoute(
    AppLocalizations l10n,
    FlightDetail flight,
    FlightDetail? selected,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: context.sp(10),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: context.rh(5)),
        Text(
          "${selected?.originAirport?.desc} - ${selected?.destinationAirport?.desc} | ${DateFormat("EEE dd MMM, yyyy", 'vi').format(DateTime.parse(selected?.dateTimeStart ?? ''))}",
        ),
        SizedBox(height: context.rh(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _timeCol(flight.timeStart ?? "", flight.departureCode ?? ""),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DottedLine(dashColor: Colors.grey, dashLength: 4),
              ),
            ),
            _timeCol(flight.timeEnd ?? "", flight.arrivalCode ?? ""),
          ],
        ),
        SizedBox(height: context.rh(16)),
      ],
    );
  }

  Widget _timeCol(String time, String code) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: context.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          code,
          style: TextStyle(color: Colors.grey, fontSize: context.sp(12)),
        ),
      ],
    );
  }

  Widget _buildPassengerInfo(FlightPassengerResponse p, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.flight_summary_passenger_label(p.index ?? 0),
            style: TextStyle(
              fontSize: context.sp(11),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.rh(4)),
          _buildDetailRow(
            l10n.flight_summary_fullname,
            "${p.firstName} ${p.lastName}",
          ),
          _buildDetailRow(
            l10n.flight_summary_birthday,
            FormatDate.parseStringToDateString(p.birthday ?? '').toString(),
          ),
          _buildDetailRow(l10n.flight_summary_passport, p.passport ?? "N/A"),
          _buildDetailRow(
            l10n.flight_summary_nationality,
            p.nationality ?? "N/A",
          ),
          const Divider(height: 20, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int value, String title, String url) {
    return Column(
      children: [
        RadioListTile<int>(
          value: value,
          groupValue: _selectedPaymentMethod,
          onChanged: (val) =>
              setState(() => _selectedPaymentMethod = val as int),
          activeColor: kPrimaryColor,
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.sp(14),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: context.rw(48)),
          child: Wrap(spacing: context.rw(10), children: [Image.asset(url)]),
        ),
      ],
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    bool isLoading,
    VoidCallback onPay,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(context.padding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _isTermsAccepted,
                  activeColor: kPrimaryColor,
                  onChanged: (v) => setState(() => _isTermsAccepted = v!),
                ),
              ),
              SizedBox(width: context.rw(8)),
              Expanded(
                child: Text(
                  l10n.flight_summary_terms_agree,
                  style: TextStyle(fontSize: context.sp(12)),
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(16)),
          SizedBox(
            width: double.infinity,
            height: context.rh(50),
            child: ElevatedButton(
              onPressed: (_isTermsAccepted && !isLoading) ? onPay : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      l10n.flight_summary_pay_now,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnsupportedAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông báo"),
        content: const Text("Hiện chưa hỗ trợ phương thức thanh toán này"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }
}
