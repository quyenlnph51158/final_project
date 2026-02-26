import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../../data/models/flight_info.dart';
import '../../../data/models/international_flight_pair.dart';
import '../../../data/models/inventory.dart';
import '../../controller/flight_controller.dart';
import '../../widgets/flight_result_card/flight_result_card.dart';
import '../../widgets/flight_result_card/intl_flight_result_card.dart';

class SelectedFlightTicketSection extends StatefulWidget {
  final FlightInfo? flight;
  final Inventory? inventory;
  final bool isOutbound;
  final InternationalFlightPair? intlPair;

  const SelectedFlightTicketSection({
    super.key,
    this.flight,
    this.inventory,
    required this.isOutbound,
    this.intlPair,
  });

  @override
  State<SelectedFlightTicketSection> createState() =>
      _SelectedFlightTicketSectionState();
}

class _SelectedFlightTicketSectionState
    extends State<SelectedFlightTicketSection> {
  // Each instance manages its OWN expansion state independently
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.intlPair != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: FlightLayoutSpacing.selectedTicketPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.selected_international_pair_ticket,
                    style: FlightStyle.sectionTitleBold(context),
                  ),
                  TextButton(
                    onPressed: () => context
                        .read<FlightController>()
                        .backToSelectOutboundFlights(),
                    child: Text(
                      l10n.text_change_btn,
                      style: FlightStyle.textButtonPrimary(context),
                    ),
                  ),
                ],
              ),
              // Dùng thẻ quốc tế riêng biệt
              IntlFlightResultCard(
                pair: widget.intlPair!,
                isExpanded: _isExpanded,
                onTap: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.flight == null)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    // This MUST return a Sliver to work in your CustomScrollView
    return SliverToBoxAdapter(
      child: Padding(
        padding: FlightLayoutSpacing.selectedTicketPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isOutbound ? l10n.selected_departure_flight_ticket : l10n.selected_arrival_flight_ticket,
                  style: FlightStyle.sectionTitleBold(context),
                ),
                TextButton(
                  onPressed: () {
                    final controller = context.read<FlightController>();
                    if (widget.isOutbound) {
                      controller.backToSelectOutboundFlights();
                    } else {
                      controller.backToSelectReturnFlights();
                    }
                  },
                  child: Text(
                    l10n.text_change_btn,
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
            FlightResultCard(
              flight: widget.flight!,
              isExpanded: _isExpanded,
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              SelectedInventory: widget.inventory,
            ),
          ],
        ),
      ),
    );
  }
}
