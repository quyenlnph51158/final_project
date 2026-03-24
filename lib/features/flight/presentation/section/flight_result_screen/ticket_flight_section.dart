import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_style.dart'; // Đảm bảo có style
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
      return const _SliverEmptyState();
    }

    if (!isInternational && displayResults.isEmpty) {
      return const _SliverEmptyState();
    }

    // 3. HIỂN THỊ DANH SÁCH QUỐC TẾ
    if (isInternational) {
      return SliverPadding(
        padding: FlightLayoutSpacing.resultListPadding,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final pair = state.data.internationalFlights[index];
            final bool isExpanded = _expandedIndex == index;
            return IntlFlightResultCard(
              pair: pair,
              isExpanded: isExpanded,
              onTap: () =>
                  setState(() => _expandedIndex = isExpanded ? null : index),
            );
          }, childCount: state.data.internationalFlights.length),
        ),
      );
    }

    // 4. HIỂN THỊ DANH SÁCH NỘI ĐỊA
    return SliverPadding(
      padding: FlightLayoutSpacing.resultListPadding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final flight = displayResults[index];
          return FlightResultCard(
            flight: flight,
            isExpanded: _expandedIndex == index,
            onTap: () => setState(
                  () => _expandedIndex = _expandedIndex == index ? null : index,
            ),
          );
        }, childCount: displayResults.length),
      ),
    );
  }
}

// Widget thông báo rỗng dạng Sliver
class _SliverEmptyState extends StatelessWidget {
  const _SliverEmptyState();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "Không tìm thấy chuyến bay",
              style: FlightStyle.sectionTitleBold(context).copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            const Text(
              "Vui lòng thay đổi lựa chọn hoặc bộ lọc.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}