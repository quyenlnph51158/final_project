import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';

// Import Constants & Theme
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/data/constants/flight_policy_data.dart';
import '../../../../../core/data/constants/flight_policy_translate.dart';

// Import UI Configs (Các file thông số kỹ thuật đã tách)
import '../../../../../core/design/flight/flight_divider.dart';
import '../../../../../core/design/flight/flight_elevation.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';

// Import Utils
import '../../../../../core/utils/responsive_layout.dart';
import '../../../../../core/utils/format_date.dart';
import '../../../../../core/utils/format_duration.dart';
import '../../../../../core/utils/format_price.dart';
import '../../../../../core/utils/format_time.dart';

// Import Features
import '../../../../policy/presentation/screens/policy_screen.dart';
import '../../../data/models/international_flight_pair.dart';
import '../../../data/models/inventory.dart';
import '../../controller/flight_controller.dart';

class IntlFlightResultCard extends StatefulWidget {
  final InternationalFlightPair pair;
  final bool isExpanded;
  final VoidCallback onTap;

  const IntlFlightResultCard({
    super.key,
    required this.pair,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<IntlFlightResultCard> createState() => _IntlFlightResultCardState();
}

class _IntlFlightResultCardState extends State<IntlFlightResultCard> {
  int _activeTabIndex = 0;
  int _selectedFareIndex = 0;

  @override
  void initState() {
    super.initState();
    _syncSelectionWithGlobalState();
  }

  void _syncSelectionWithGlobalState() {
    final state = context.read<FlightController>().state;
    final isThisPairSelected =
        state.data.selectedInternationalFlight?.outbound.flightCode ==
        widget.pair.outbound.flightCode;

    if (isThisPairSelected && state.data.selectedOutboundInventory != null) {
      final index = widget.pair.syncedInventories.indexWhere(
        (element) =>
            element.outbound.fareType ==
            state.data.selectedOutboundInventory!.fareType,
      );

      if (index != -1) {
        setState(() => _selectedFareIndex = index);
      }
    }
  }

  @override
  void didUpdateWidget(covariant IntlFlightResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSelectionWithGlobalState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<FlightController>().state;

    final bool isThisPairSelected =
        state.data.selectedInternationalFlight?.outbound.flightCode ==
        widget.pair.outbound.flightCode;

    final Inventory outboundInven;
    final Inventory returnInven;

    if (isThisPairSelected && state.data.selectedOutboundInventory != null) {
      outboundInven = state.data.selectedOutboundInventory!;
      returnInven = state.data.selectedReturnInventory!;
    } else {
      final selectedPair = widget.pair.syncedInventories[_selectedFareIndex];
      outboundInven = selectedPair.outbound;
      returnInven = selectedPair.returnFlight;
    }

    final int currentPairPrice =
        outboundInven.totalPrice + returnInven.totalPrice;
    final String currentFareType = outboundInven.fareType;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
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
            borderRadius: FlightShape.borderRadiusLarge(context),
            child: Padding(
              padding: EdgeInsets.all(FlightLayoutSpacing.paddingAll(context)),
              child: Column(
                children: [
                  _buildSummaryRow(
                    context,
                    widget.pair.outbound,
                    price: currentPairPrice,
                  ),
                  SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
                  _buildSummaryRow(
                    context,
                    widget.pair.returnFlight,
                    isReturn: true,
                  ),
                ],
              ),
            ),
          ),

          if (widget.isExpanded) ...[
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
                  ),
                ],
              ),
            ),

            _activeTabIndex == 0
                ? _buildTicketClassSelector(context, isThisPairSelected, state)
                : _buildTimelineSection(context, currentFareType),

            SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
          ],
        ],
      ),
    );
  }

  Widget _buildTicketClassSelector(
    BuildContext context,
    bool isPairSelected,
    dynamic state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final fareOptions = widget.pair.syncedInventories;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: FlightLayoutSpacing.gapSmall(context),
      ),
      child: Row(
        children: List.generate(fareOptions.length, (index) {
          final pairItem = fareOptions[index];
          bool isThisClassSelected = false;

          if (isPairSelected == true &&
              state.data.selectedOutboundInventory != null) {
            isThisClassSelected =
                state.data.selectedOutboundInventory!.fareType ==
                pairItem.outbound.fareType;
          } else {
            isThisClassSelected = _selectedFareIndex == index;
          }

          final int totalPriceForThisClass =
              pairItem.outbound.totalPrice + pairItem.returnFlight.totalPrice;

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
                color: isThisClassSelected ? kPrimaryColor : kBorderColor,
                width: isThisClassSelected
                    ? FlightShape.borderThick
                    : FlightShape.borderThin,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        FormatPrice.formatPrice(totalPriceForThisClass),
                        style: FlightStyle.priceLarge(context),
                      ),
                      Text(
                        pairItem.outbound.fareType,
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
                    setState(() => _selectedFareIndex = index);
                    if (isPairSelected == false) {
                      context.read<FlightController>().selectInternationalPair(
                        widget.pair,
                        fareIndex: index,
                      );
                    } else {
                      context
                          .read<FlightController>()
                          .updateInternationalClassSelector(
                            pairItem.outbound,
                            pairItem.returnFlight,
                          );
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
                    isThisClassSelected
                        ? l10n.currentlySelected
                        : l10n.selectThisJourney,
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
        }),
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

  Widget _buildTimelineSection(BuildContext context, String fareType) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(FlightLayoutSpacing.paddingAll(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, l10n.departureDetails),
          _buildVerticalTimeline(context, widget.pair.outbound, fareType),
          SizedBox(height: FlightLayoutSpacing.tabGap),
          _buildSectionTitle(context, l10n.returnDetails),
          _buildVerticalTimeline(context, widget.pair.returnFlight, fareType),
        ],
      ),
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

  Widget _buildSummaryRow(
    BuildContext context,
    dynamic flight, {
    int? price,
    bool isReturn = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Image.network(
          flight.logo,
          width: FlightSize.logoMain(context),
          height: FlightSize.logoMain(context),
          fit: BoxFit.contain,
        ),
        SizedBox(width: FlightLayoutSpacing.gapMedium(context)),
        _buildTimeBox(
          context,
          FormatTime.formatHHmmFromIso(flight.departureDate),
          flight.departureCode,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                FormatDuration.formatDuration(flight.totalDuration, l10n),
                style: FlightStyle.durationSmall(context),
              ),
              Padding(
                padding: FlightLayoutSpacing.dottedLinePadding,
                child: DottedLine(
                  dashColor: kTextColor,
                  lineThickness: FlightDivider.dashThickness,
                ),
              ),
              if (flight.stopNo > 0)
                Text(
                  l10n.stops(flight.stopNo),
                  style: FlightStyle.stopPointText(context),
                ),
            ],
          ),
        ),
        _buildTimeBox(
          context,
          FormatTime.formatHHmmFromIso(flight.arrivalDate),
          flight.arrivalCode,
          isEnd: true,
        ),
        SizedBox(width: FlightLayoutSpacing.gapMedium(context)),
        if (price != null)
          Text(
            FormatPrice.formatPrice(price),
            style: FlightStyle.priceMedium(context),
          )
        else
          Icon(
            widget.isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: kPrimaryColor,
          ),
      ],
    );
  }

  Widget _buildVerticalTimeline(
    BuildContext context,
    dynamic flight,
    String fareType,
  ) {
    return Column(
      children: List.generate(flight.stopInfos.length, (index) {
        final segment = flight.stopInfos[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlightSegment(
              context,
              flight: flight,
              segment: segment,
              fareType: fareType,
            ),
            if (index < flight.stopInfos.length - 1)
              _buildStopPoint(
                context,
                AppLocalizations.of(context)!,
                segment.layoverDuration,
                segment.destinationAirportObject.desc,
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTimeBox(
    BuildContext context,
    String time,
    String code, {
    bool isEnd = false,
  }) {
    return Column(
      crossAxisAlignment: isEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(time, style: FlightStyle.timeLarge(context)),
        Text(code, style: FlightStyle.codeGrey(context)),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: FlightStyle.sectionTitle(context));
  }

  Widget _buildFlightSegment(
    BuildContext context, {
    required dynamic flight,
    required dynamic segment,
    required String fareType,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: FlightLayoutSpacing.timelineIndent(context),
          child: Column(
            children: [
              _buildTimelineTime(
                context,
                segment.timeStart,
                FormatDate.formatDateDDMMYYYY(
                  DateTime.parse(segment.dateTimeStart),
                ),
              ),
              SizedBox(
                height:
                    FlightDivider.timelineConnectorHeight -
                    FlightLayoutSpacing.timelineTimeGap,
              ),
              _buildTimelineTime(
                context,
                segment.timeEnd,
                FormatDate.formatDateDDMMYYYY(
                  DateTime.parse(segment.dateTimeEnd),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: FlightLayoutSpacing.timelineGap(context)),
        Column(
          children: [
            Icon(
              Icons.circle,
              size: FlightSize.iconTimelineDot(context),
              color: kPrimaryColor,
            ),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAirportText(
                context,
                segment.departureCode,
                segment.originAirportObject.airline,
              ),
              SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
              Row(
                children: [
                  Image.network(
                    flight.logo,
                    width: FlightSize.logoSmall(context),
                    height: FlightSize.logoSmall(context),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: FlightLayoutSpacing.gapSmall(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flight.airlineSystemText,
                          style: FlightStyle.segmentFlightCode(context),
                        ),
                        Text(
                          l10n.flight_fareAndCode(fareType, flight.flightCode),
                          style: FlightStyle.segmentSubText(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: FlightLayoutSpacing.gapMedium(context)),
              _buildAirportText(
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
        mainAxisSize: MainAxisSize.min,
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

  Widget _buildFeatureRow(BuildContext context, String key) {
    final String translatedText = FlightPolicyTranslate.getTranslation(
      context,
      key,
    );
    final IconData icon = FlightPolicyTranslate.getIcon(key);

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
}
