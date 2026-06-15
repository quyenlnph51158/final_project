import 'package:dotted_line/dotted_line.dart';
import 'package:final_project/core/utils/format_duration.dart';
import 'package:final_project/core/utils/format_price.dart';
import 'package:final_project/features/flight/data/models/flight_detail.dart';
import 'package:final_project/features/flight/data/models/flight_inventory.dart';
import 'package:final_project/features/flight/data/models/stop_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/data/constants/flight_policy_translate.dart';
import '../../../../../core/data/constants/flight_policy_data.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../../policy/presentation/screens/policy_screen.dart';
import '../../../data/models/flight_item.dart';
import '../../controller/flight_controller.dart';

class FlightResultCard extends StatefulWidget {
  final FlightItem flight; // Đổi từ FlightDetail sang FlightItem
  final bool isExpanded;
  final VoidCallback onTap;
  final FlightInventory? selectedInventory;

  const FlightResultCard({
    super.key,
    required this.flight,
    required this.isExpanded,
    required this.onTap,
    this.selectedInventory,
  });

  @override
  State<FlightResultCard> createState() => _FlightResultCardState();
}

class _FlightResultCardState extends State<FlightResultCard> {
  late FlightInventory _selectedInventory;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSelectedInventory();
  }

  @override
  void didUpdateWidget(FlightResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi ID chuyến bay thay đổi hoặc dữ liệu từ bên ngoài thay đổi, cần khởi tạo lại
    if (oldWidget.flight.uniqueId != widget.flight.uniqueId ||
        oldWidget.selectedInventory != widget.selectedInventory) {
      _initializeSelectedInventory();
    }
  }

  void _initializeSelectedInventory() {
    final state = context.read<FlightController>().state;
    final inventories = widget.flight.go?.inventories ?? [];

    // --- SO SÁNH THEO ĐỐI TƯỢNG DETAIL ---
    FlightInventory? savedInven;
    // Kiểm tra chặng đi
    if (state.data.selectedOutboundFlight == widget.flight.go) {
      savedInven = state.data.selectedOutboundInventory;
    }
    // Kiểm tra chặng về
    else if (state.data.selectedReturnFlight == widget.flight.go) {
      savedInven = state.data.selectedReturnInventory;
    }

    if (savedInven != null) {
      _selectedInventory = savedInven;
    } else if (inventories.isNotEmpty) {
      _selectedInventory = inventories.first;
    } else {
      _selectedInventory = FlightInventory.fromJson({});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<FlightController>().state;
    final flightDetail = widget.flight.go;

    if (flightDetail == null) return const SizedBox.shrink();

    // Xác định inventory đang được chọn thực tế (ưu tiên state toàn cục)
    final FlightInventory? globalSelectedInventory =
    (state.data.selectedOutboundFlight == flightDetail)
        ? state.data.selectedOutboundInventory
        : (state.data.selectedReturnFlight == flightDetail)
        ? state.data.selectedReturnInventory
        : null;

    final currentDisplayInventory = globalSelectedInventory ?? _selectedInventory;

    final String depTime = flightDetail.timeStart ?? "--:--";
    final String arrTime = flightDetail.timeEnd ?? "--:--";
    final String duration = FormatDuration.formatDuration(
      flightDetail.totalDuration ?? 0,
      l10n,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(
        vertical: context.rh(8),
        horizontal: context.padding,
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
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(context.radius),
            child: Padding(
              padding: EdgeInsets.all(context.rw(16)),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          flightDetail.airlineObject?.logo ?? '',
                          width: context.icon(35),
                          height: context.icon(35),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.flight_takeoff,
                            color: kPrimaryColor,
                            size: context.icon(30),
                          ),
                        ),
                      ),
                      SizedBox(width: context.rw(12)),
                      Expanded(
                        child: _buildRouteBrief(
                          context,
                          depTime,
                          arrTime,
                          flightDetail.departureCode ?? "",
                          flightDetail.arrivalCode ?? "",
                          duration,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: context.rh(24),
                    color: kBorderColor.withOpacity(0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${flightDetail.airlineSystemText} | ${flightDetail.flightCode}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      _buildPriceBrief(
                        context,
                        currentDisplayInventory.totalPrice ?? 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const Divider(height: 1),
                _buildTabHeader(context, l10n),
                _activeTabIndex == 0
                    ? _buildTicketClassSelector(
                        context,
                        globalSelectedInventory,
                      )
                    : _buildFlightDetailTimeline(context, flightDetail),
                SizedBox(height: context.rh(16)),
              ],
            ),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.rh(12),
        horizontal: context.rw(16),
      ),
      child: Row(
        children: [
          _tabButton(context, l10n.selectSeatClass, 0),
          SizedBox(width: context.rw(20)),
          _tabButton(context, l10n.flightDetails, 1),
        ],
      ),
    );
  }

  Widget _tabButton(BuildContext context, String title, int index) {
    final bool isActive = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? kPrimaryColor : Colors.grey,
            ),
          ),
          SizedBox(height: context.rh(4)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? context.rw(30) : 0,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRouteBrief(
    BuildContext context,
    String dep,
    String arr,
    String depCode,
    String arrCode,
    String duration,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeNode(context, dep, depCode, CrossAxisAlignment.start),
        Expanded(
          child: Column(
            children: [
              Text(
                duration,
                style: TextStyle(
                  fontSize: context.sp(11),
                  color: Colors.grey.shade600,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(8),
                  vertical: context.rh(4),
                ),
                child: DottedLine(
                  dashColor: Colors.grey.shade400,
                  lineThickness: 1,
                ),
              ),
            ],
          ),
        ),
        _buildTimeNode(context, arr, arrCode, CrossAxisAlignment.end),
      ],
    );
  }

  Widget _buildTimeNode(
    BuildContext context,
    String time,
    String code,
    CrossAxisAlignment align,
  ) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: context.sp(18),
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        Text(
          code,
          style: TextStyle(fontSize: context.sp(13), color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPriceBrief(BuildContext context, int price) {
    return Row(
      children: [
        Text(
          FormatPrice.formatPrice(price),
          style: TextStyle(
            fontSize: context.sp(18),
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        SizedBox(width: context.rw(4)),
        AnimatedRotation(
          turns: widget.isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 250),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: context.icon(24),
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketClassSelector(
    BuildContext context,
    FlightInventory? currentSelected,
  ) {
    final inventories = widget.flight.go?.inventories ?? [];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.rw(8)),
      child: Row(
        children: inventories.map((inventory) {
          bool isSelected = currentSelected?.fareType == inventory.fareType;
          return _buildTicketCard(context, isSelected, inventory);
        }).toList(),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    bool isSelected,
    FlightInventory inventory,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: context.rw(260).clamp(240.0, 300.0),
      margin: EdgeInsets.all(context.rw(8)),
      padding: EdgeInsets.all(context.rw(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(
          color: isSelected ? kPrimaryColor : kBorderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            FormatPrice.formatPrice(inventory.totalPrice ?? 0),
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          Text(
            inventory.fareType ?? "",
            style: TextStyle(
              fontSize: context.sp(13),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: context.rh(24)),
          ...FlightPolicyData.policyFlight
              .take(3)
              .map((f) => _buildFeatureRow(context, f.text)),
          SizedBox(height: context.rh(16)),
          ElevatedButton(
            onPressed: () {
              setState(() => _selectedInventory = inventory);
              _selectFlight(context, widget.flight, inventory);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: Size(double.infinity, context.rh(40)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius * 0.6),
              ),
              elevation: 0,
            ),
            child: Text(
              isSelected ? l10n.currentlySelected : l10n.selectThisJourney,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: context.rh(8)),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PolicyScreen(postId: 37),
              ),
            ),
            child: Text(
              l10n.viewDetails,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: context.sp(13),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(6)),
      child: Row(
        children: [
          Icon(
            FlightPolicyTranslate.getIcon(text),
            size: context.icon(14),
            color: Colors.green,
          ),
          SizedBox(width: context.rw(8)),
          Expanded(
            child: Text(
              FlightPolicyTranslate.getTranslation(context, text),
              style: TextStyle(
                fontSize: context.sp(12),
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetailTimeline(BuildContext context, FlightDetail detail) {
    final stopInfos = detail.stopInfos ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(16),
        vertical: context.rh(10),
      ),
      child: Column(
        children: List.generate(stopInfos.length, (index) {
          final segment = stopInfos[index];
          return Column(
            children: [
              _buildFlightSegment(
                context,
                segment,
                detail.airlineSystemText ?? "",
                detail.airlineObject?.logo ?? '',
              ),
              if (index < stopInfos.length - 1)
                _buildStopPoint(
                  context,
                  segment.layoverDuration ?? 0,
                  segment.destinationAirport?.desc ?? "",
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFlightSegment(
    BuildContext context,
    StopInfo segment,
    String airlineName,
    String urlImage,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.rw(55),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _timeTextSmall(context, segment.timeStart ?? ""),
                _timeTextSmall(context, segment.timeEnd ?? ""),
              ],
            ),
          ),
          SizedBox(
            width: context.rw(30),
            child: Column(
              children: [
                Icon(
                  Icons.radio_button_checked,
                  size: context.icon(16),
                  color: kPrimaryColor,
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: kPrimaryColor.withOpacity(0.3),
                  ),
                ),
                Icon(
                  Icons.location_on,
                  size: context.icon(16),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _airportInfo(
                  context,
                  segment.originAirport?.airline ?? "",
                  segment.originAirport?.desc ?? "",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.rh(12)),
                  child: Row(
                    children: [
                      if (urlImage.isNotEmpty)
                        Image.network(
                          urlImage,
                          height: context.icon(20),
                          width: context.icon(20),
                        )
                      else
                        Icon(
                          Icons.flight,
                          size: context.icon(18),
                          color: kPrimaryColor,
                        ),
                      SizedBox(width: context.rw(8)),
                      Expanded(
                        child: Text(
                          "$airlineName • ${segment.flightCode}",
                          style: TextStyle(
                            fontSize: context.sp(12),
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _airportInfo(
                  context,
                  segment.destinationAirport?.airline ?? "",
                  segment.destinationAirport?.desc ?? "",
                ),
                SizedBox(height: context.rh(10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeTextSmall(BuildContext context, String time) => Text(
    time,
    style: TextStyle(
      fontSize: context.sp(15),
      fontWeight: FontWeight.bold,
      color: kTextColor,
    ),
  );

  Widget _airportInfo(BuildContext context, String code, String cityName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        Text(
          cityName,
          style: TextStyle(
            fontSize: context.sp(12),
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStopPoint(BuildContext context, int duration, String city) {
    final h = duration ~/ 60;
    final m = duration % 60;
    return Row(
      children: [
        SizedBox(width: context.rw(55)),
        SizedBox(
          width: context.rw(30),
          child: Center(
            child: Container(
              width: 1.5,
              height: context.rh(40),
              color: kPrimaryColor.withOpacity(0.3),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: context.rh(8)),
            padding: EdgeInsets.symmetric(
              vertical: context.rh(6),
              horizontal: context.rw(12),
            ),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withOpacity(0.2)),
            ),
            child: Text(
              "Dừng tại $city: ${h}h ${m}m",
              style: TextStyle(
                fontSize: context.sp(11),
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectFlight(
    BuildContext context,
    FlightItem flight,
    FlightInventory selectedInventory,
  ) {
    final controller = context.read<FlightController>();
    final isViewingReturn = controller.state.ui.isViewingReturnFlights;
    // Đồng bộ: Nếu là FlightResultCard nội địa, ta gọi selectFlight (đã gộp Outbound/Return dựa trên flag)
    controller.selectFlight(
      flight,
      selectedInventory,
      isOutbound: !isViewingReturn,
    );
  }
}
