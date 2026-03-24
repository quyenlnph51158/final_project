import 'package:dotted_line/dotted_line.dart';
import 'package:final_project/core/data/constants/flight_policy_data.dart';
import 'package:final_project/core/utils/format_date.dart';
import 'package:final_project/core/utils/format_duration.dart';
import 'package:final_project/core/utils/format_price.dart';
import 'package:final_project/features/flight/data/models/fare_detail.dart';
import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/data/constants/flight_policy_translate.dart';
import '../../../../../core/design/flight/flight_divider.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../../policy/presentation/screens/policy_screen.dart';
import '../../../data/models/inventory.dart';
import '../../controller/flight_controller.dart';

class FlightResultCard extends StatefulWidget {
  final FlightInfo flight;
  final bool isExpanded;
  final VoidCallback onTap;
  final Inventory? SelectedInventory;

  const FlightResultCard({
    super.key,
    required this.flight,
    required this.isExpanded,
    required this.onTap,
    this.SelectedInventory,
  });

  @override
  State<FlightResultCard> createState() => _FlightResultCardState();
}

class _FlightResultCardState extends State<FlightResultCard> {
  // Sử dụng late và đảm bảo khởi tạo trong initState để không bao giờ null
  late Inventory _selectedInventory;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSelectedInventory();
  }

  void _initializeSelectedInventory() {
    // 1. Ưu tiên Inventory được truyền vào từ widget
    if (widget.SelectedInventory != null) {
      _selectedInventory = widget.SelectedInventory!;
    }
    // 2. Nếu không có, lấy phần tử đầu tiên của danh sách inventories nếu không rỗng
    else if (widget.flight.inventories.isNotEmpty) {
      _selectedInventory = widget.flight.inventories.first;
    }
    // 3. TRƯỜNG HỢP PHÒNG THỦ: Nếu API lỗi trả về inventories rỗng, tạo dữ liệu dummy để tránh Crash
    else {
      _selectedInventory = Inventory(
        features: [],
        seatClass: '',
        fareType: '',
        available: 0,
        adultFare: FareDetail(fare: 0, charge: 0, price: 0),
        totalPrice: 0,
        currency: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<FlightController>().state;

    // Xác định Inventory đang được chọn toàn cục (nếu có)
    Inventory? globalSelectedInventory;
    if (state.data.selectedOutboundFlight?.flightCode ==
        widget.flight.flightCode) {
      globalSelectedInventory = state.data.selectedOutboundInventory;
    } else if (state.data.selectedReturnFlight?.flightCode ==
        widget.flight.flightCode) {
      globalSelectedInventory = state.data.selectedReturnInventory;
    }

    final bool isSummaryMode = globalSelectedInventory != null;
    // Đảm bảo currentDisplayInventory luôn có dữ liệu (không bao giờ null)
    final currentDisplayInventory =
        globalSelectedInventory ?? _selectedInventory;

    // Định dạng thời gian/ngày tháng an toàn
    final String depTime = widget.flight.timeStart;
    final String arrTime = widget.flight.timeEnd;
    final String depDate = FormatDate.formatDateDDMMYYYY(
      DateTime.tryParse(widget.flight.departureDate) ?? DateTime.now(),
    );
    final String arrDate = FormatDate.formatDateDDMMYYYY(
      DateTime.tryParse(widget.flight.arrivalDate) ?? DateTime.now(),
    );
    final String duration = FormatDuration.formatDuration(
      widget.flight.totalDuration,
      l10n,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(
        vertical: FlightLayoutSpacing.cardMarginV(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: FlightShape.borderRadiusLarge(context),
        border: Border.all(color: kBorderColor, width: FlightShape.borderThin),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.all(FlightLayoutSpacing.paddingAll(context)),
              child: Row(
                children: [
                  Image.network(
                    widget.flight.logo,
                    width: FlightSize.logoMain(context),
                    height: FlightSize.logoMain(context),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.flight_takeoff, color: kPrimaryColor),
                  ),
                  SizedBox(width: FlightLayoutSpacing.gapMedium(context)),
                  Expanded(
                    child: _buildRouteBrief(
                      context,
                      depTime,
                      arrTime,
                      widget.flight.departureCode,
                      widget.flight.arrivalCode,
                      duration,
                    ),
                  ),
                  SizedBox(width: FlightLayoutSpacing.gapMedium(context)),
                  _buildPriceBrief(context, currentDisplayInventory.totalPrice),
                ],
              ),
            ),
          ),

          // Phần nội dung mở rộng
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            sizeCurve: Curves.easeInOut,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Column(
              children: [
                Padding(
                  padding: FlightLayoutSpacing.tabPadding,
                  child: Row(
                    children: [
                      _buildTabItem(
                        context,
                        l10n.selectSeatClass,
                        isActive: _activeTabIndex == 0,
                        onTap: () => setState(() => _activeTabIndex = 0),
                      ),
                      SizedBox(width: FlightLayoutSpacing.tabGap),
                      _buildTabItem(
                        context,
                        l10n.flightDetails,
                        isActive: _activeTabIndex == 1,
                        onTap: () => setState(() => _activeTabIndex = 1),
                        icon: Icons.flight_takeoff,
                      ),
                    ],
                  ),
                ),

                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: _buildTicketClassSelector(
                    context,
                    state,
                    isSummaryMode,
                    currentDisplayInventory,
                  ),
                  secondChild: _buildFlightDetailTimeline(
                    context,
                    depTime,
                    arrTime,
                    depDate,
                    arrDate,
                  ),
                  crossFadeState: _activeTabIndex == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
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

  // --- WIDGETS CON ---

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
        _buildTimeNode(context, dep, depCode),
        Expanded(
          child: Column(
            children: [
              Text(duration, style: FlightStyle.durationSmall(context)),
              const Padding(
                padding: FlightLayoutSpacing.dottedLinePadding,
                child: DottedLine(
                  dashColor: kTextColor,
                  lineThickness: FlightDivider.dashThickness,
                ),
              ),
            ],
          ),
        ),
        _buildTimeNode(context, arr, arrCode),
      ],
    );
  }

  Widget _buildTimeNode(BuildContext context, String time, String code) {
    return Column(
      children: [
        Text(time, style: FlightStyle.timeLarge(context)),
        Text(code, style: FlightStyle.codeGrey(context)),
      ],
    );
  }

  Widget _buildPriceBrief(BuildContext context, int price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          FormatPrice.formatPrice(price),
          style: FlightStyle.priceMedium(context),
        ),
        AnimatedRotation(
          turns: widget.isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 250),
          child: const Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String title, {
    required bool isActive,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: FlightSize.iconTab(context),
                  color: isActive ? kPrimaryColor : Colors.grey,
                ),
              SizedBox(width: FlightLayoutSpacing.gapSmall(context) / 2),
              Text(
                title,
                style: isActive
                    ? FlightStyle.tabActive(context)
                    : FlightStyle.tabInactive(context),
              ),
            ],
          ),
          SizedBox(height: FlightLayoutSpacing.gapSmall(context) / 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: FlightSize.tabIndicatorHeight,
            width: isActive ? FlightSize.tabIndicatorWidth : 0,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketClassSelector(
    BuildContext context,
    dynamic state,
    bool isSummaryMode,
    Inventory displayInventory,
  ) {
    if (widget.flight.inventories.isEmpty) {
      return const Center(child: Text("Không có hạng vé khả dụng"));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.flight.inventories.map((inventory) {
            // So sánh dựa trên object hoặc ID/FareType để xác định trạng thái chọn
            bool isSelected = _selectedInventory == inventory;
            return _buildTicketCard(context, state, isSelected, inventory);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    dynamic state,
    bool isSelected,
    Inventory inventory,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: FlightSize.fareCardWidth(context),
      margin: EdgeInsets.symmetric(
        horizontal: FlightLayoutSpacing.gapSmall(context),
        vertical: FlightLayoutSpacing.cardMarginV(context),
      ),
      padding: EdgeInsets.all(FlightLayoutSpacing.paddingAll(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: FlightShape.borderRadiusLarge(context),
        border: Border.all(
          color: isSelected ? kPrimaryColor : kBorderColor,
          width: isSelected ? FlightShape.borderThick : FlightShape.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  FormatPrice.formatPrice(inventory.totalPrice),
                  style: FlightStyle.priceLarge(context),
                ),
                Text(
                  inventory.fareType,
                  style: FlightStyle.fareTypeBold(context),
                ),
              ],
            ),
          ),
          Divider(height: FlightDivider.dividerHeight),
          ...FlightPolicyData.policyFlight
              .take(3)
              .map((f) => _buildFeatureRow(context, f.text)),
          SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
          ElevatedButton(
            onPressed: () {
              setState(() => _selectedInventory = inventory);
              if (widget.SelectedInventory == null) {
                _selectFlight(context, widget.flight, inventory);
              } else {
                _updateClassSelector(context, widget.flight, inventory);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: Size(
                double.infinity,
                FlightSize.btnSelectHeight(context),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: FlightShape.borderRadiusSmall(context),
              ),
            ),
            child: Text(
              isSelected ? l10n.currentlySelected : l10n.selectThisJourney,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: FlightLayoutSpacing.gapSmall(context)),
          _buildPolicyAndBooking(context),
        ],
      ),
    );
  }

  Widget _buildPolicyAndBooking(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PolicyScreen(postId: 37),
          ),
        ),
        child: Text(
          l10n.viewDetails,
          style: TextStyle(color: kPrimaryColor, fontSize: context.sp(16)),
        ),
      ),
    );
  }

  Widget _buildFlightDetailTimeline(
    BuildContext context,
    String depT,
    String arrT,
    String depD,
    String arrD,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(widget.flight.stopInfos.length, (index) {
          final segment = widget.flight.stopInfos[index];

          return Column(
            children: [
              // Vẽ chặng bay hiện tại
              _buildFlightSegment(
                context,
                timeStart: segment.timeStart,
                dateStart: FormatDate.formatDateDDMMYYYY(
                  DateTime.parse(segment.dateTimeStart),
                ),
                timeEnd: segment.timeEnd,
                dateEnd: FormatDate.formatDateDDMMYYYY(
                  DateTime.parse(segment.dateTimeEnd),
                ),
                airportStart: segment.departureCode,
                airportEnd: segment.arrivalCode,
                airportNameStart: segment.originAirportObject.airline,
                airportNameEnd: segment.destinationAirportObject.airline,
                flightCode: segment.flightCode,
                // Số hiệu riêng từng chặng (VD: VJ165, VJ085)
                planeModel:
                    segment.airPlaneModel, // Loại máy bay (VD: 321, 330)
              ),

              // Nếu chưa phải chặng cuối, vẽ thông tin Transit (Layover)
              if (index < widget.flight.stopInfos.length - 1)
                _buildStopPoint(
                  context,
                  l10n,
                  segment.layoverDuration, // Thời gian chờ (phút)
                  segment.destinationAirportObject.desc, // Tên thành phố chờ
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFlightSegment(
    BuildContext context, {
    required String timeStart,
    required String dateStart,
    required String timeEnd,
    required String dateEnd,
    required String airportStart,
    required String airportEnd,
    required String airportNameStart,
    required String airportNameEnd,
    required String flightCode, // Thêm số hiệu chặng
    required String planeModel, // Thêm loại máy bay
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột thời gian
        Column(
          children: [
            _buildTimelineTime(context, timeStart, dateStart),
            SizedBox(
              height:
                  FlightDivider.timelineConnectorHeight -
                  FlightLayoutSpacing.timelineTimeGap,
            ),
            // Tăng chiều cao để đủ chỗ cho thông tin ở giữa
            _buildTimelineTime(context, timeEnd, dateEnd),
          ],
        ),
        SizedBox(width: FlightLayoutSpacing.timelineGap(context)),
        // Cột đường kẻ Timeline
        Column(
          children: [
            Icon(Icons.circle, size: 10, color: kPrimaryColor),
            Container(
              width: FlightDivider.timelineLineThickness,
              height: FlightDivider.timelineConnectorHeight,
              color: kPrimaryColor.withOpacity(0.3),
            ),
            Icon(
              Icons.circle,
              size: FlightSize.iconTimelineDot(context),
              color: kPrimaryColor,
            ),
          ],
        ),
        SizedBox(width: FlightLayoutSpacing.timelineGap(context)),
        // Cột thông tin sân bay và máy bay
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAirportText(context, airportStart, airportNameStart),
              SizedBox(height: FlightLayoutSpacing.gapMedium(context)),

              // Thông tin hãng và máy bay chặng này
              Row(
                children: [
                  Image.network(
                    widget.flight.logo,
                    width: FlightSize.logoSmall(context),
                    height: FlightSize.logoSmall(context),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: FlightLayoutSpacing.gapSmall(context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.flight.airlineSystemText,
                        style: FlightStyle.segmentFlightCode(context),
                      ),
                      Text(
                        l10n.flight_fareAndCode(
                          _selectedInventory.fareType,
                          flightCode,
                        ),
                        style: FlightStyle.segmentSubText(context),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: context.hp(2)),
              _buildAirportText(context, airportEnd, airportNameEnd),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTime(BuildContext context, String time, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time, style: FlightStyle.timelineTime(context)),
        Text(date, style: FlightStyle.timelineDate(context)),
      ],
    );
  }

  Widget _buildAirportText(BuildContext context, String code, String name) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: code, style: FlightStyle.airportCode(context)),
          TextSpan(text: " • ", style: FlightStyle.airportName(context)),
          TextSpan(text: name, style: FlightStyle.airportName(context)),
        ],
      ),
    );
  }

  Widget _buildStopPoint(
    BuildContext context,
    AppLocalizations l10n,
    int layoverMinutes,
    String cityName,
  ) {
    // Chuyển đổi phút sang giờ:phút
    final hours = layoverMinutes ~/ 60;
    final minutes = layoverMinutes % 60;
    final durationStr = hours > 0 ? "${hours}h ${minutes}m" : "${minutes}m";

    return Container(
      margin: FlightLayoutSpacing.stopPointMargin,
      padding: FlightLayoutSpacing.stopPointPadding,
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: FlightShape.borderRadiusSmall(context),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: Colors.orange,
            size: FlightSize.iconSmall(context),
          ),
          SizedBox(width: FlightLayoutSpacing.gapIcon),
          Text(
            l10n.stopAt(cityName, durationStr),
            style: FlightStyle.stopPointText(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, String text) {
    final String translatedText = FlightPolicyTranslate.getTranslation(
      context,
      text,
    );
    final IconData icon = FlightPolicyTranslate.getIcon(text);

    return Padding(
      padding: EdgeInsets.only(
        bottom: FlightLayoutSpacing.featurePaddingBottom,
      ),
      child: Row(
        children: [
          Icon(icon, size: FlightSize.iconSmall(context), color: kPrimaryColor),
          SizedBox(width: FlightLayoutSpacing.gapIcon),
          Flexible(
            child: Text(
              translatedText,
              style: FlightStyle.featureText(context),
            ),
          ),
        ],
      ),
    );
  }

  void _updateClassSelector(
    BuildContext context,
    FlightInfo flight,
    Inventory inven,
  ) {
    final controller = context.read<FlightController>();
    if (controller.state.data.selectedOutboundFlight?.flightCode ==
        flight.flightCode) {
      controller.updateOutboundFlightClassSelector(inven);
    } else {
      controller.updateReturnFlightClassSelector(inven);
    }
  }

  void _selectFlight(
    BuildContext context,
    FlightInfo flight,
    Inventory selectedInventory,
  ) {
    final controller = context.read<FlightController>();
    if (controller.state.criteria.roundTrip == false ||
        (controller.state.criteria.roundTrip == true &&
            controller.state.ui.isViewingReturnFlights == false)) {
      controller.selectOutboundFlight(flight, selectedInventory);
    } else {
      controller.selectReturnFlight(flight, selectedInventory);
      controller.scrollToTop();
    }
  }
}
