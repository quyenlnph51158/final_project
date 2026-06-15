import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../widgets/flight_result_card/flight_result_card.dart';
import '../../widgets/flight_result_card/intl_flight_result_card.dart';

class TicketFlightSection extends StatefulWidget {
  final bool isViewingReturn;

  const TicketFlightSection({super.key, required this.isViewingReturn});

  @override
  State<TicketFlightSection> createState() => _TicketFlightSectionState();
}

class _TicketFlightSectionState extends State<TicketFlightSection> {
  int? _expandedIndex;

  @override
  void didUpdateWidget(covariant TicketFlightSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isViewingReturn != widget.isViewingReturn) {
      setState(() {
        _expandedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FlightController>().state;

    // 1. Xác định loại chuyến bay và danh sách hiển thị
    final bool isInternational = state.data.internationalFlights.isNotEmpty;
    final displayResults = widget.isViewingReturn
        ? state.data.returnFlights
        : state.data.outboundFlights;

    // 2. KIỂM TRA TRẠNG THÁI RỖNG
    if (isInternational && state.data.internationalFlights.isEmpty) {
      return const _BoxEmptyState(); // Đổi từ Sliver sang Box
    }

    if (!isInternational && displayResults.isEmpty) {
      return const _BoxEmptyState(); // Đổi từ Sliver sang Box
    }

    // 3. HIỂN THỊ DANH SÁCH QUỐC TẾ (Đã chuyển sang ListView)
    if (isInternational) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.rh(10.0),
          // horizontal: context.rw(16.0),
        ),
        child: ListView.builder(
          shrinkWrap: true, // Quan trọng: Cho phép ListView nằm trong Column
          physics: const NeverScrollableScrollPhysics(), // Sử dụng cuộn của CustomScrollView bên ngoài
          itemCount: state.data.internationalFlights.length,
          itemBuilder: (context, index) {
            final pair = state.data.internationalFlights[index];
            final bool isExpanded = _expandedIndex == index;
            return IntlFlightResultCard(
              pair: pair,
              isExpanded: isExpanded,
              onTap: () => setState(() => _expandedIndex = isExpanded ? null : index),
            );
          },
        ),
      );
    }

    // 4. HIỂN THỊ DANH SÁCH NỘI ĐỊA (Đã chuyển sang ListView)
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.rh(10.0),
        // horizontal: context.rw(16.0),
      ),
      child: ListView.builder(
        shrinkWrap: true, // Quan trọng
        physics: const NeverScrollableScrollPhysics(), // Quan trọng
        itemCount: displayResults.length,
        itemBuilder: (context, index) {
          final flight = displayResults[index];
          return FlightResultCard(
            flight: flight,
            isExpanded: _expandedIndex == index,
            onTap: () => setState(
                  () => _expandedIndex = _expandedIndex == index ? null : index,
            ),
          );
        },
      ),
    );
  }
}

// Widget thông báo rỗng dạng Box (Thay thế cho SliverFillRemaining)
class _BoxEmptyState extends StatelessWidget {
  const _BoxEmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              l10n.no_flights_found,
              style: TextStyle(
                fontSize: context.sp(16),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.change_filter_instruction,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}