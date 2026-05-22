import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/utils/format_date.dart';
import 'package:final_project/core/utils/format_duration.dart';
import 'package:final_project/features/train/data/models/seat_class.dart';
import 'package:final_project/features/train/data/models/train_model.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:final_project/features/train/presentation/modals/detail_device_bottom_sheet.dart';
import 'package:final_project/features/train/presentation/modals/vip_seat_explanation_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/responsive_layout.dart';

class TrainTicketCard extends StatefulWidget {
  final TrainModel train;
  final SeatClass? seat;

  const TrainTicketCard({super.key, required this.train, this.seat});

  @override
  State<TrainTicketCard> createState() => _TrainTicketCardState();
}

class _TrainTicketCardState extends State<TrainTicketCard> {
  bool _isExpanded = false;
  int? _selectedSeatIndex;

  @override
  void initState() {
    super.initState();
    _syncSelectedSeat();
  }

  @override
  void didUpdateWidget(covariant TrainTicketCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.seat != oldWidget.seat) {
      _syncSelectedSeat();
    }
  }

  void _syncSelectedSeat() {
    if (widget.seat != null && widget.train.seatClass != null) {
      final index = widget.train.seatClass!.indexWhere(
        (seat) => seat.title == widget.seat?.title,
      );
      if (index != -1) {
        setState(() {
          _selectedSeatIndex = index;
          _isExpanded = true;
        });
      }
    } else {
      setState(() => _selectedSeatIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TrainController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(8), // Thay h(1) bằng rh(8)
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: kBorderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Phần thông tin chính (Header)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(context.radius),
            child: Padding(
              padding: EdgeInsets.all(context.padding),
              child: Row(
                children: [
                  // Ga đi
                  Expanded(
                    flex: 3,
                    child: _buildStationInfo(
                      widget.train.timeStart ?? "20:00",
                      widget.train.departure ?? "Ga Hà Nội",
                      true,
                    ),
                  ),

                  // Center (Thời gian di chuyển & Mã tàu)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Text(
                          FormatDuration.formatDuration(
                            widget.train.duration ?? 130,
                            l10n,
                          ),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: context.sp(11),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: context.rh(4),
                            horizontal: context.rw(8),
                          ),
                          child: Divider(
                            color: kPrimaryColor.withOpacity(0.5),
                            thickness: 1.5,
                          ),
                        ),
                        Text(
                          "${widget.train.trainCode ?? 'SP4'} - ${widget.train.carrier?.name}",
                          style: TextStyle(
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D2D2D),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Ga đến
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildStationInfo(
                          widget.train.timeEnd ?? "22:10",
                          widget.train.arrival ?? "Ga Sài Gòn",
                          false,
                        ),
                        SizedBox(width: context.rw(4)),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: kPrimaryColor,
                          size: context.icon(22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Danh sách hạng ghế
          if (widget.train.seatClass != null)
            ...widget.train.seatClass!.asMap().entries.map((entry) {
              int idx = entry.key;
              var seat = entry.value;
              bool isSelected = _selectedSeatIndex == idx;
              return InkWell(
                onTap: () {
                  setState(() => _selectedSeatIndex = idx);
                  if (widget.seat != null) {
                    controller.updateSelectedTrain(seat);
                  } else {
                    controller.selectDepartureTrain(widget.train, seat);
                    // 2. Đợi frame tiếp theo khi danh sách Lượt về đã xuất hiện
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (controller.state.form.isRoundTrip) {
                        controller.scrollToKey(controller.returnTrainList);
                      }
                      if((controller.state.form.isRoundTrip && controller.state.ui.isSelectedDepartureTrain && controller.state.ui.isSelectedReturnTrain)||
                          (!controller.state.form.isRoundTrip && controller.state.ui.isSelectedDepartureTrain)
                      ){
                        controller.scrollToKey(controller.continueButton);
                      }
                    });
                  }
                },
                child: _buildSeatOption(
                  title: seat.title ?? l10n.seat_class_default,
                  price: seat.price!,
                  showInfoIcon: seat.title!.toLowerCase().contains("size"),
                  isSelected: isSelected,
                ),
              );
            }),

          // Lộ trình chi tiết
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _builDetailTimeLine(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          SizedBox(height: context.rh(4)),
        ],
      ),
    );
  }

  Widget _buildStationInfo(String time, String station, bool isStart) {
    return Column(
      crossAxisAlignment: isStart
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: context.sp(17),
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        Text(
          station,
          style: TextStyle(fontSize: context.sp(11), color: kHintTextColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSeatOption({
    required String title,
    required num price,
    bool showInfoIcon = false,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(10), // Thay h(1.2) bằng rh(10)
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: context.sp(14),
                      color: kTextColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showInfoIcon) ...[
                  SizedBox(width: context.rw(6)),
                  Icon(
                    Icons.info_outline,
                    size: context.icon(14),
                    color: kHintTextColor,
                  ),
                ],
              ],
            ),
          ),
          Text(
            price.toString(),
            style: TextStyle(
              fontSize: context.sp(15),
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(width: context.rw(12)),
          Container(
            width: context.icon(18),
            height: context.icon(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? kPrimaryColor : kBorderColor,
                width: isSelected ? 5 : 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _builDetailTimeLine() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: context.rh(24), color: Colors.grey.shade200),

          // --- PHẦN LỘ TRÌNH CHÍNH ---
          IntrinsicHeight( // Giúp đường dọc nối liền các điểm
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cột thời gian (Giờ đi - Khoảng trắng - Giờ đến)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateTimeColumn(
                      widget.train.timeStart ?? "20:00",
                      FormatDate.parseStringToDateString(widget.train.dateTimeStart!) ?? "",
                      isStart: true,
                    ),
                    _buildDateTimeColumn(
                      widget.train.timeEnd ?? "22:10",
                      FormatDate.parseStringToDateString(widget.train.dateTimeEnd!) ?? "",
                      isStart: false,
                    ),
                  ],
                ),

                SizedBox(width: context.rw(8)),

                // 2. Cột Timeline (Dot - Line - Dot)
                Column(
                  children: [
                    SizedBox(height: context.rh(6)), // Đẩy dot xuống cho giữa text giờ
                    _buildTimelineDot(kPrimaryColor, context.icon(8)),
                    Expanded(
                      child: Container(
                        width: 1.5,
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                    ),
                    _buildTimelineDot(kPrimaryColor, context.icon(8)),
                    SizedBox(height: context.rh(6)), // Đệm dưới tương ứng
                  ],
                ),

                SizedBox(width: context.rw(12)),

                // 3. Cột Tên Ga (Ga đi - Khoảng trắng - Ga đến)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStationName(
                        widget.train.fromStation?.name ?? "",
                        l10n.station_with_name(widget.train.originStationObject?.name ?? ""),
                      ),
                      // Khoảng nghỉ giữa 2 ga (Tự động dãn nhờ MainAxisAlignment.spaceBetween)
                      SizedBox(height: context.rh(20)),
                      _buildStationName(
                        widget.train.toStation?.name ?? "",
                        l10n.station_with_name(widget.train.destinationStationObject?.name ?? ""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- PHẦN THÔNG TIN CHI TIẾT PHÍA DƯỚI ---
          SizedBox(height: context.rh(24)),
          _buildInfoLink(
            l10n.device,
            widget.train.trainCode ?? "SP4",
            onpress: () => VipSeatExplanationBottomSheet.show(context),
          ),
          _buildInfoLink(
            l10n.carrier,
            "${widget.train.carrier?.name}",
            onpress: () => DetailDeviceBottomSheet.show(context, widget.train.carrier!),
          ),
          _buildInfoRow(l10n.distance, "${widget.train.distance ?? 0} km"),
          _buildInfoRow(
            l10n.duration_label,
            FormatDuration.formatDuration(widget.train.duration ?? 0, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeColumn(String time, String date, {required bool isStart}) {
    return SizedBox(
      width: context.rw(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2D2D),
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: context.sp(10),
              color: Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildStationName(String city, String stationName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          city,
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF455A64),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          stationName,
          style: TextStyle(
            fontSize: context.sp(12),
            color: Colors.blueGrey,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rh(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: context.sp(13), color: Colors.blueGrey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLink(
    String label,
    String value, {
    required VoidCallback onpress,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rh(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: context.sp(13), color: Colors.blueGrey),
          ),
          GestureDetector(
            onTap: onpress,
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.sp(13),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF006677),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
