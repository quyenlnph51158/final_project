import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/flight/data/models/flight_inventory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../data/models/flight_item.dart';
import '../../controller/flight_controller.dart';
import '../../widgets/flight_result_card/flight_result_card.dart';
import '../../widgets/flight_result_card/intl_flight_result_card.dart';

class SelectedFlightTicketSection extends StatefulWidget {
  final FlightItem? flight;
  final FlightInventory? inventory;
  final bool isOutbound;
  final FlightItem? intlPair;

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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.intlPair == null && widget.flight == null) {
      return const SizedBox.shrink();
    }

    // 1. Tính toán logic Title và Action (Giữ nguyên)
    String title = "";
    VoidCallback onChange;
    if (widget.intlPair != null) {
      title = l10n.selected_international_pair_ticket;
      onChange = () => context.read<FlightController>().backToSelectOutboundFlights();
    } else {
      title = widget.isOutbound
          ? l10n.selected_departure_flight_ticket
          : l10n.selected_arrival_flight_ticket;
      onChange = () {
        final controller = context.read<FlightController>();
        if (widget.isOutbound) {
          controller.backToSelectOutboundFlights();
        } else {
          controller.backToSelectReturnFlights();
        }
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- PHẦN 1: TÁCH RIÊNG TITLE HEADER ---
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.padding, // Đây là "Tab distance" - lề trái phải của tiêu đề
          ).copyWith(
            top: context.rh(20.0),
            bottom: context.rh(8.0), // Khoảng cách dưới tiêu đề
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: onChange,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.text_change_btn,
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ).copyWith(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- PHẦN 2: CARD NỘI DUNG ---
        // Nếu muốn Card sát lề hơn hoặc rộng hơn Title, bạn chỉnh padding ở đây
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0, // Để 0 nếu Card đã có padding bên trong, hoặc bằng context.padding
          ).copyWith(
            bottom: context.rh(10.0),
          ),
          child: widget.intlPair != null
              ? IntlFlightResultCard(
            pair: widget.intlPair!,
            isExpanded: _isExpanded,
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          )
              : FlightResultCard(
            flight: widget.flight!,
            isExpanded: _isExpanded,
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            selectedInventory: widget.inventory,
          ),
        ),
      ],
    );
  }
}