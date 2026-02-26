import 'package:final_project/core/utils/format_duration.dart';
import 'package:final_project/core/utils/format_price.dart';
import 'package:final_project/core/utils/format_time.dart';
import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/inventory.dart';
import '../controller/flight_controller.dart';
import 'package:intl/intl.dart';

class FlightResultCard extends StatelessWidget{
  final FlightInfo flight;
  final String departureCode;
  final String destinationCode;
  final String departureDate;
  final String returnDate;
  final int adults;
  final int children;
  final int infant;
  final bool isRoundTrip;
  const FlightResultCard({
    super.key,
    required this.flight,
    this.departureCode = 'Hà Nội (HAN)',
    this.destinationCode = 'Hồ Chí Minh (SGN)',
    this.departureDate = '10/12/2025',
    this.returnDate = '15/12/2025',
    this.adults = 1,
    this.children = 0,
    this.infant = 0,
    this.isRoundTrip = true,
  });
  @override
  Widget build(BuildContext context) {
    final state=context.watch<FlightController>().state;
    final l10n = AppLocalizations.of(context)!;
    final String departureTime = FormatTime.formatHHmmFromIso(flight.departureDate);
    final String arrivalTime = FormatTime.formatHHmmFromIso(flight.arrivalDate);
    final String airportFrom = flight.departureCode;
    final String airportTo = flight.arrivalCode;
    final String duration = FormatDuration.formatDuration( flight.totalDuration,l10n);
    final String totalStopsText = flight.stopNo == 0 ? l10n.flight_directFlight : '${flight.stopNo} ${l10n.flight_stopNo}';
    final Color stopColor = flight.stopNo == 0 ? kPrimaryColor : Colors.orange;
    final String airlineLogoUrl = flight.logo;
    bool isExpanded = false;
    Inventory _selectedInventory = flight.inventories.first;

    return StatefulBuilder(
      builder: (context, setState) {
        final String price = FormatPrice.formatPrice(_selectedInventory.totalPrice);
        final String flightClass = _selectedInventory.seatClass;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          elevation: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          airlineLogoUrl,
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.airplanemode_active, color: kPrimaryColor),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.airlineSystemText,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                flight.flightCode,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        _buildTimeAndAirport(departureTime, airportFrom, CrossAxisAlignment.end),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            const Icon(Icons.arrow_right_alt, color: kPrimaryColor),
                            Text(
                              duration,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        _buildTimeAndAirport(arrivalTime, airportTo, CrossAxisAlignment.start),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          totalStopsText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: stopColor,
                          ),
                        ),
                        if (flight.inventories.length > 1)
                          DropdownButton<Inventory>(
                            value: _selectedInventory,
                            icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryColor),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black87),
                            underline: Container(
                              height: 1,
                              color: kPrimaryColor,
                            ),
                            onChanged: (Inventory? newValue) {
                              setState(() {
                                _selectedInventory = newValue!;
                                isExpanded = false;
                              });
                            },
                            items: flight.inventories.map<DropdownMenuItem<Inventory>>((Inventory inventory) {
                              return DropdownMenuItem<Inventory>(
                                value: inventory,
                                child: Text(
                                  '${inventory.seatClass} - ${inventory.fareType} ',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                          )
                        else
                          Text(
                            flightClass,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                      ],
                    ),

                    const Divider(height: 25, color: kSidebarDividerColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            Text(
                              'VND',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              // ĐIỀU CHỈNH LOGIC ON PRESSED ĐỂ CHỌN CHUYẾN BAY
                              _selectFlight(context, flight, _selectedInventory);
                              if(state.selectedOutboundFlight!=null) {
                                print('chuyến bay chiều đi');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              // ĐỔI TEXT TÙY THEO TRẠNG THÁI
                              state.isViewingReturnFlights ? l10n.flight_selectReturnTicket : l10n.flight_selectOutboundTicket,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_selectedInventory.features.isNotEmpty)
                Column(
                  children: [
                    Divider(height: 0, color: Colors.grey.shade300),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isExpanded ? l10n.flight_shrink : l10n.flight_readDetailPolicyTicket,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                        child: Column(
                          children: _selectedInventory.features.map((feature) {
                            return _buildFeatureRow(context, feature);
                          }).toList(),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildFeatureRow(BuildContext context ,String text) {
    final l10n = AppLocalizations.of(context)!;
    IconData icon;
    Color color;

    if (text.contains(l10n.flight_luggage)) {
      icon = Icons.luggage_outlined;
      color = Colors.grey.shade600;
    } else if (text.contains(l10n.flight_change)) {
      icon = Icons.swap_horiz;
      color = kPrimaryColor;
    } else if (text.contains(l10n.flight_returnTicket)) {
      icon = Icons.cancel_outlined;
      color = Colors.red.shade700;
    } else {
      icon = Icons.check_circle_outline;
      color = kPrimaryColor;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTimeAndAirport(String time, String airportCode, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          airportCode,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
  _selectFlight(BuildContext context ,FlightInfo flight, Inventory selectedInventory) {
    final controller = context.read<FlightController>();
    final state=controller.state;
    if (state.typeAirport==2 && !state.isViewingReturnFlights) {
      // BƯỚC 1: CHỌN CHUYẾN ĐI
      controller.selectOutboundFlight(flight);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã chọn chuyến đi ${flight.flightCode}. Vui lòng chọn chuyến về',
          ),
        ),
      );
    } else {
      // BƯỚC 2: CHỌN CHUYẾN VỀ HOẶC MỘT CHIỀU
      controller.selectReturnFlight(flight);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã chọn chuyến ${!state.roundTrip ? 'một chiều' : 'về'} '
                '${flight.flightCode}, Hạng ghế: ${selectedInventory.seatClass}',
          ),
        ),
      );

      controller.scrollToTop();

      // TODO: navigate sang trang thanh toán
    }

  }
}