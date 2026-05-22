import 'package:dotted_line/dotted_line.dart';
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
import '../../../../../core/data/constants/flight_policy_data.dart';
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
  late Inventory _selectedInventory;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSelectedInventory();
  }

  void _initializeSelectedInventory() {
    if (widget.SelectedInventory != null) {
      _selectedInventory = widget.SelectedInventory!;
    } else if (widget.flight.inventories.isNotEmpty) {
      _selectedInventory = widget.flight.inventories.first;
    } else {
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

    Inventory? globalSelectedInventory;
    if (state.data.selectedOutboundFlight?.flightCode ==
        widget.flight.flightCode) {
      globalSelectedInventory = state.data.selectedOutboundInventory;
    } else if (state.data.selectedReturnFlight?.flightCode ==
        widget.flight.flightCode) {
      globalSelectedInventory = state.data.selectedReturnInventory;
    }

    final bool isSummaryMode = globalSelectedInventory != null;
    final currentDisplayInventory =
        globalSelectedInventory ?? _selectedInventory;

    final String depTime = widget.flight.timeStart;
    final String arrTime = widget.flight.timeEnd;
    final String duration = FormatDuration.formatDuration(
      widget.flight.totalDuration,
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
                          widget.flight.logo,
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
                          widget.flight.departureCode,
                          widget.flight.arrivalCode,
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
                        '${widget.flight.airlineSystemText} | ${widget.flight.flightCode}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: context.sp(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      _buildPriceBrief(
                        context,
                        currentDisplayInventory.totalPrice,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Phần nội dung mở rộng (Tab Class & Timeline)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const Divider(height: 1),
                _buildTabHeader(context, l10n),
                _activeTabIndex == 0
                    ? _buildTicketClassSelector(context, state)
                    : _buildFlightDetailTimeline(context),
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

  Widget _buildTicketClassSelector(BuildContext context, dynamic state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.rw(8)),
      child: Row(
        children: widget.flight.inventories.map((inventory) {
          bool isSelected = _selectedInventory == inventory;
          return _buildTicketCard(context, isSelected, inventory);
        }).toList(),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    bool isSelected,
    Inventory inventory,
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
            FormatPrice.formatPrice(inventory.totalPrice),
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          Text(
            inventory.fareType,
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
              if (widget.SelectedInventory == null)
                _selectFlight(context, widget.flight, inventory);
              else
                _updateClassSelector(context, widget.flight, inventory);
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
              style: TextStyle(
                fontSize: context.sp(14),
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

  Widget _buildFlightDetailTimeline(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.padding),
      child: Column(
        children: List.generate(widget.flight.stopInfos.length, (index) {
          final segment = widget.flight.stopInfos[index];
          return Column(
            children: [
              _buildFlightSegment(context, segment),
              if (index < widget.flight.stopInfos.length - 1)
                _buildStopPoint(
                  context,
                  segment.layoverDuration,
                  segment.destinationAirportObject.desc,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFlightSegment(BuildContext context, dynamic segment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _timeText(
              context,
              segment.timeStart,
              FormatDate.formatDateDDMMYYYY(
                DateTime.parse(segment.dateTimeStart),
              ),
            ),
            Container(
              width: 1,
              height: context.rh(60),
              color: kPrimaryColor.withOpacity(0.3),
            ),
            _timeText(
              context,
              segment.timeEnd,
              FormatDate.formatDateDDMMYYYY(
                DateTime.parse(segment.dateTimeEnd),
              ),
            ),
          ],
        ),
        SizedBox(width: context.rw(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _airportTitle(
                context,
                segment.departureCode,
                segment.originAirportObject.airline,
              ),
              SizedBox(height: context.rh(15)),
              Row(
                children: [
                  Image.network(
                    widget.flight.logo,
                    width: context.icon(24),
                    height: context.icon(24),
                  ),
                  SizedBox(width: context.rw(8)),
                  Text(
                    "${widget.flight.airlineSystemText} • ${segment.flightCode}",
                    style: TextStyle(
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rh(15)),
              _airportTitle(
                context,
                segment.arrivalCode,
                segment.destinationAirportObject.airline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeText(BuildContext context, String time, String date) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          date,
          style: TextStyle(fontSize: context.sp(10), color: Colors.grey),
        ),
      ],
    );
  }

  Widget _airportTitle(BuildContext context, String code, String name) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: context.sp(14), color: kTextColor),
        children: [
          TextSpan(
            text: code,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " • $name",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildStopPoint(BuildContext context, int duration, String city) {
    final h = duration ~/ 60;
    final m = duration % 60;
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.rh(12)),
      padding: EdgeInsets.symmetric(
        vertical: context.rh(6),
        horizontal: context.rw(12),
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.radius / 2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: Colors.orange,
            size: context.icon(16),
          ),
          SizedBox(width: context.rw(8)),
          Text(
            "Dừng tại $city trong ${h}h ${m}m",
            style: TextStyle(
              fontSize: context.sp(12),
              color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic Điều hướng giữ nguyên ---
  void _updateClassSelector(
    BuildContext context,
    FlightInfo flight,
    Inventory inven,
  ) {
    final controller = context.read<FlightController>();
    if (controller.state.data.selectedOutboundFlight?.flightCode ==
        flight.flightCode)
      controller.updateOutboundFlightClassSelector(inven);
    else
      controller.updateReturnFlightClassSelector(inven);
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
