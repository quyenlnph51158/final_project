import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/controller/payment_controller.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../core/utils/responsive_layout.dart';

class TrainBookingSummaryScreen extends StatefulWidget {
  const TrainBookingSummaryScreen({super.key});

  @override
  State<TrainBookingSummaryScreen> createState() =>
      _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<TrainBookingSummaryScreen> {
  int _paymentMethod = 1;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final isPaymentLoading = context.watch<PaymentController>().isLoading;
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TrainController>().state;
    final booking = state.data.summaryTrainResponseData?.booking;
    final bookin_sid = state.data.summaryTrainResponseData?.bookingSid;
    final passengers =
        state
            .data
            .summaryTrainResponseData
            ?.booking
            ?.bookingInfo
            ?.passengers ??
        [];
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding),
        child: Column(
          children: [
            Text(
              "Xem lại đặt chỗ của bạn",
              style: TextStyle(
                fontSize: context.sp(20),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: context.rh(16)),

            // PHẦN 1: THÔNG TIN ĐẶT VÉ
            _buildSectionCard(
              context,
              title: "Thông tin đặt vé",
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    "Mã đặt chỗ:",
                    booking?.bookingCode ?? '',
                    isValueBold: true,
                  ),
                  SizedBox(height: context.rh(12)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hạn thanh toán",
                        style: TextStyle(
                          fontSize: context.sp(14),
                          color: Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              FormatDate.formatDate(booking?.paymentExpiredAt),
                              style: TextStyle(
                                fontSize: context.sp(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "(sau thời gian này, mã\nđặt chỗ sẽ bị hủy)",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: context.sp(12),
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rh(16)),

            _buildSectionCard(
              context,
              title: "Thông tin",
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    "Họ tên",
                    booking?.customer?.fullName ?? '',
                    isValueBold: true,
                  ),
                  _buildInfoRow(
                    context,
                    "Số điện thoại",
                    booking?.customerPhone ?? '',
                    isValueBold: true,
                  ),
                  _buildInfoRow(
                    context,
                    "Ngày đặt",
                    "14:30, 20 Th8, 2025",
                    isValueBold: true,
                  ),
                  _buildInfoRow(
                    context,
                    "Email",
                    booking?.customerEmail ?? '',
                    isValueBold: true,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.rh(16)),
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),

                  // TỔNG TIỀN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng",
                        style: TextStyle(
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            booking?.amount ?? '',
                            style: TextStyle(
                              fontSize: context.sp(20),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF006D7C),
                            ),
                          ),
                          Text(
                            booking?.currency ?? '',
                            style: TextStyle(
                              fontSize: context.sp(14),
                              color: const Color(0xFF006D7C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: context.rw(8)),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: const Color(0xFF006D7C),
                            size: context.icon(20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.rh(12)),

                  // CHI TIẾT GIÁ
                  _buildPriceItem(
                    context,
                    "Giá cơ bản",
                    booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainGoFareClassSelected
                            ?.price
                            .toString() ??
                        '',
                  ),
                  _buildPriceItem(
                    context,
                    "Thuế & Phí",
                    booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainGoFareClassSelected
                            ?.tax
                            .toString() ??
                        '',
                  ),
                  _buildPriceItem(context, "Phí dịch vụ", "0 đ"),
                  _buildPriceItem(context, "Xe buýt", "100.000 đ"),
                ],
              ),
            ),
            SizedBox(height: context.rh(30)),

            // PHẦN 1: HÀNH TRÌNH
            _buildSectionCard(
              context,
              title: "Hành trình",
              trailing: "Chi tiết hành trình",
              child: Column(
                children: [
                  _buildFlightInfo(
                    context,
                    type: "KHỞI HÀNH",
                    route:
                        "${booking?.bookingInfo?.trainInfo?.trainSelected?.go?.originStationObject?.name} ${l10n.to} ${booking?.bookingInfo?.trainInfo?.trainSelected?.go?.destinationStationObject?.name}",
                    date:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.dateTimeStart ??
                        '',
                    startTime:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.timeStart ??
                        '',
                    endTime:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.timeEnd ??
                        '',
                    startCode:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.departure ??
                        '',
                    endCode:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.arrival ??
                        '',
                    trainInfo:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.trainName ??
                        '',
                    durationTime:
                        booking
                            ?.bookingInfo
                            ?.trainInfo
                            ?.trainSelected
                            ?.go
                            ?.duration ??
                        0,
                  ),
                  if (booking?.request?.typeTrip == 2) ...[
                    Divider(height: context.rh(32)),
                    _buildFlightInfo(
                      context,
                      type: "TRỞ VỀ",
                      route:
                          "${booking?.bookingInfo?.trainInfo?.trainSelected?.returnTrain?.originStationObject?.name} ${l10n.to} ${booking?.bookingInfo?.trainInfo?.trainSelected?.returnTrain?.destinationStationObject?.name} ",
                      date:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.dateTimeStart ??
                          '',
                      startTime:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.timeStart ??
                          '',
                      endTime:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.timeEnd ??
                          '',
                      startCode:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.departure ??
                          '',
                      endCode:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.arrival ??
                          '',
                      trainInfo:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.trainName ??
                          '',
                      durationTime:
                          booking
                              ?.bookingInfo
                              ?.trainInfo
                              ?.trainSelected
                              ?.returnTrain
                              ?.duration ??
                          0,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.rh(16)),

            // PHẦN 2: THÔNG TIN HÀNH KHÁCH
            _buildSectionCard(
              context,
              title: "Thông tin hành khách",
              child: Column(
                children: [
                  for (var i in passengers) ...[
                    _buildPassengerInfo(
                      context,
                      i.index ?? 0,
                      i.fullName ?? '',
                      i.birthday ?? '',
                      i.passport ?? '',
                      i.nationality ?? '',
                    ),

                    if (i != passengers.last) _buildPassengerDivider(context),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.rh(16)),

            // PHẦN 3: PHƯƠNG THỨC THANH TOÁN
            _buildSectionCard(
              context,
              title: "Phương thức thanh toán",
              child: Column(
                children: [
                  RadioListTile<int>(
                    value: 1,
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                    activeColor: const Color(0xFF006D7C),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Thanh toán bằng thẻ Tín dụng/Ghi nợ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: context.rw(48)),
                    child: Wrap(
                      spacing: context.rw(10),
                      children: [
                        Image.asset(
                          'assets/icons/icon_creditcard_debitcard.png',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.rh(10)),
                  RadioListTile<int>(
                    value: 2,
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                    activeColor: const Color(0xFF006D7C),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Thanh toán bằng Apple Pay",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: context.rw(60)),
                    child: Wrap(
                      spacing: context.rw(10),
                      children: [Image.asset('assets/icons/icon_applepay.png')],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rh(20)),

            // ĐIỀU KHOẢN
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.rw(24),
                  width: context.rw(24),
                  child: Checkbox(
                    value: _agreedToTerms,
                    onChanged: (val) => setState(() => _agreedToTerms = val!),
                  ),
                ),
                SizedBox(width: context.rw(8)),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Tôi đã đọc và đồng ý với tất cả ",
                      children: [
                        TextSpan(
                          text: "Điều khoản sử dụng",
                          style: TextStyle(
                            color: const Color(0xFF006D7C),
                            fontWeight: FontWeight.bold,
                            fontSize: context.sp(13),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: " được quy định."),
                      ],
                    ),
                    style: TextStyle(fontSize: context.sp(13)),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rh(20)),

            // NÚT TIẾP TỤC
            SizedBox(
              width: double.infinity,
              height: context.rh(50),
              child: ElevatedButton(
                onPressed: (isPaymentLoading || !_agreedToTerms)
                    ? null
                    : () {
                  context.read<PaymentController>().startPaymentFlow(
                      context,
                      state.data.summaryTrainResponseData?.bookingSid ?? ''
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D7C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radius),
                  ),
                ),
                child: isPaymentLoading
                    ? SizedBox(
                  height: context.rh(20),
                  width: context.rh(20),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  "Tiếp tục",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.rh(40)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HỖ TRỢ ĐÃ ÁP DỤNG RESPONSIVE ---

  Widget _buildPriceItem(BuildContext context, String label, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rh(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: context.sp(14)),
          ),
          Text(
            price,
            style: TextStyle(
              color: Colors.black,
              fontSize: context.sp(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    String? trailing,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: Colors.grey.shade200),
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
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trailing != null)
                Text(
                  trailing,
                  style: TextStyle(
                    color: const Color(0xFF006D7C),
                    fontSize: context.sp(13),
                    decoration: TextDecoration.underline,
                  ),
                ),
            ],
          ),
          Divider(height: context.rh(24)),
          child,
        ],
      ),
    );
  }

  Widget _buildFlightInfo(
    BuildContext context, {
    required String type,
    required String route,
    required String date,
    required String startTime,
    required String endTime,
    required String startCode,
    required String endCode,
    required String trainInfo,
    required int durationTime,
  }) {
    Duration duration = Duration(minutes: durationTime);

    int hours = duration.inHours; // 2
    int minutes = duration.inMinutes.remainder(60); // 15

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.sp(11),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.rh(6)),
        Text(
          "$route | $date",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.sp(13),
          ),
        ),
        SizedBox(height: context.rh(12)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  startTime,
                  style: TextStyle(
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  startCode,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: context.sp(12),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "${hours}h${minutes}",
                    style: TextStyle(
                      fontSize: context.sp(10),
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.rw(10)),
                    child: const Divider(thickness: 1),
                  ),
                  Text(
                    trainInfo,
                    style: TextStyle(
                      fontSize: context.sp(10),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  endTime,
                  style: TextStyle(
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  endCode,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: context.sp(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassengerInfo(
    BuildContext context,
    int index,
    String name,
    String dob,
    String id,
    String nation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "KHÁCH HÀNG $index",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.sp(11),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.rh(8)),
        _buildInfoRow(context, "Họ tên", name),
        _buildInfoRow(context, "Ngày sinh", dob),
        _buildInfoRow(context, "Số CCCD/ Passport", id),
        _buildInfoRow(context, "Quốc tịch", nation),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isValueBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rh(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.black87, fontSize: context.sp(13)),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rh(12)),
      child: const Divider(height: 1, thickness: 0.5),
    );
  }
}
