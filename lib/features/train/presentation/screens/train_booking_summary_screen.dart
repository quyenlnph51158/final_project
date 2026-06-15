import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/controller/payment_controller.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../core/utils/format_price.dart';
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
  bool _isPriceExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isPaymentLoading = context.watch<PaymentController>().isLoading;
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TrainController>().state;
    final booking = state.data.summaryTrainResponseData?.booking;
    final passengers =
        state.data.summaryTrainResponseData?.booking?.bookingInfo?.passengers ??
        [];
    // 1. Lấy giá tiền và làm sạch (chỉ giữ lại số)
    // Kiểm tra an toàn cho phần tử thứ nhất [0]
    String priceStr1 = '0';
    if ((booking?.bookingInfo?.extraService?.length ?? 0) > 0) {
      priceStr1 =
          booking?.bookingInfo?.extraService?[0].price?.replaceAll(
            RegExp(r'[^0-9]'),
            '',
          ) ??
          '0';
    }

    // Kiểm tra an toàn cho phần tử thứ hai [1]
    String priceStr2 = '0';
    if ((booking?.bookingInfo?.extraService?.length ?? 0) > 1) {
      priceStr2 =
          booking?.bookingInfo?.extraService?[1].price?.replaceAll(
            RegExp(r'[^0-9]'),
            '',
          ) ??
          '0';
    }
    // 2. Chuyển sang số và tính tổng
    int busTotal =
        (int.tryParse(priceStr1) ?? 0) + (int.tryParse(priceStr2) ?? 0);

    // 3. Định dạng lại để hiển thị (thêm dấu chấm phân cách nếu muốn)
    // Ví dụ: 200000 -> "200.000 đ"
    String formattedTotal =
        "${busTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
    final trainInfo = booking?.bookingInfo?.trainInfo;
    final fareGo = trainInfo?.trainGoFareClassSelected?.price ?? 0;
    final fareReturn = trainInfo?.trainReturnFareClassSelected?.price ?? 0;
    final taxGo = trainInfo?.trainGoFareClassSelected?.tax ?? 0;
    final taxReturn = trainInfo?.trainReturnFareClassSelected?.tax ?? 0;
    final totalFare = fareGo + fareReturn;
    final totalTax =
        (fareGo * (taxGo / 100)) + (fareReturn * (taxReturn / 100));
    final num totalAmount = int.parse(booking?.amount ?? '');
    final totalService = totalAmount - totalFare - totalTax - busTotal;
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding),
        child: Column(
          children: [
            Text(
              l10n.summary_title,
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
              title: l10n.summary_booking_info,
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    l10n.summary_booking_code,
                    booking?.bookingCode ?? '',
                    isValueBold: true,
                  ),
                  SizedBox(height: context.rh(12)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.summary_payment_deadline,
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
                              l10n.summary_deadline_note,
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
              title: l10n.summary_general_info,
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    l10n.summary_fullname,
                    booking?.customer?.fullName ?? '',
                    isValueBold: true,
                  ),
                  _buildInfoRow(
                    context,
                    l10n.summary_phone,
                    booking?.customerPhone ?? '',
                    isValueBold: true,
                  ),
                  _buildInfoRow(
                    context,
                    l10n.summary_booking_date,
                    DateFormat("HH:mm, dd 'Th'M, yyyy")
                        .format(DateTime.parse(booking?.createdAt ?? ''))
                        .toString(),
                    isValueBold: true,
                  ),
                  _buildInfoRow(
                    context,
                    l10n.summary_email,
                    booking?.customerEmail ?? '',
                    isValueBold: true,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.rh(16)),
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),

                  // TỔNG TIỀN
                  // Bọc toàn bộ vào AnimatedSize để tự động tính toán kích thước khi con thay đổi
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: [
                        // 1. PHẦN TỔNG TIỀN (Click vào đây để đóng/mở)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isPriceExpanded = !_isPriceExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.summary_total,
                                style: TextStyle(
                                  fontSize: context.sp(18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    FormatPrice.formatPrice(totalAmount),
                                    // Khuyên dùng format 1.000.000
                                    style: TextStyle(
                                      fontSize: context.sp(20),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF006D7C),
                                    ),
                                  ),
                                  SizedBox(width: context.rw(4)),
                                  Text(
                                    booking?.currency ?? '',
                                    style: TextStyle(
                                      fontSize: context.sp(14),
                                      color: const Color(0xFF006D7C),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: context.rw(8)),
                                  // Icon xoay theo trạng thái
                                  Icon(
                                    _isPriceExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: const Color(0xFF006D7C),
                                    size: context.icon(20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 2. PHẦN CHI TIẾT GIÁ (Sẽ trượt ra mượt mà nhờ AnimatedSize)
                        if (_isPriceExpanded) ...[
                          SizedBox(height: context.rh(12)),
                          const Divider(height: 1, thickness: 0.5),
                          SizedBox(height: context.rh(8)),

                          _buildPriceItem(
                            context,
                            l10n.summary_base_fare,
                            "${FormatPrice.formatPrice(totalFare)} ${booking?.currency ?? ''}",
                          ),
                          _buildPriceItem(
                            context,
                            l10n.summary_tax_fee,
                            "${FormatPrice.formatPrice(totalTax)} ${booking?.currency ?? ''}",
                          ),
                          // _buildPriceItem(
                          //   context,
                          //   "Phí dịch vụ",
                          //   "${FormatPrice.formatPrice(totalService)} ${booking?.currency ?? ''}",
                          // ),

                          // Hiển thị xe buýt nếu tàu là dòng SP (Sapa)
                          if ((booking
                                      ?.bookingInfo
                                      ?.trainInfo
                                      ?.trainSelected
                                      ?.go
                                      ?.trainCode ??
                                  "")
                              .contains("SP")) ...[
                            _buildPriceItem(
                              context,
                              l10n.summary_bus,
                              "$formattedTotal ${booking?.currency ?? ''}",
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rh(30)),

            // PHẦN 1: HÀNH TRÌNH
            _buildSectionCard(
              context,
              title: l10n.summary_itinerary,
              trailing: l10n.summary_itinerary_detail,
              child: Column(
                children: [
                  _buildFlightInfo(
                    context,
                    type: l10n.summary_departure_label,
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
                      type: l10n.summary_return_label,
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
              title: l10n.summary_passenger_info,
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
                      l10n,
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
              title: l10n.summary_payment_method,
              child: Column(
                children: [
                  RadioListTile<int>(
                    value: 1,
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                    activeColor: const Color(0xFF006D7C),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.summary_card_method,
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
                      l10n.summary_apple_pay,
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
                      text: l10n.summary_terms_prefix,
                      children: [
                        TextSpan(
                          text: l10n.summary_terms_link,
                          style: TextStyle(
                            color: const Color(0xFF006D7C),
                            fontWeight: FontWeight.bold,
                            fontSize: context.sp(13),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: l10n.summary_terms_suffix),
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
                        if (_paymentMethod == 1) {
                          context.read<PaymentController>().startPaymentFlow(
                            context,
                            state.data.summaryTrainResponseData?.bookingSid ??
                                '',
                          );
                        } else {
                          _showUnsupportedAlert(context);
                        }
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
                        l10n.summary_btn_continue,
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
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.summary_passenger_count(index),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.sp(11),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.rh(8)),
        _buildInfoRow(context, l10n.summary_fullname, name),
        _buildInfoRow(context, l10n.summary_dob, dob),
        _buildInfoRow(context, l10n.summary_passport, id),
        _buildInfoRow(context, l10n.summary_nationality, nation),
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
