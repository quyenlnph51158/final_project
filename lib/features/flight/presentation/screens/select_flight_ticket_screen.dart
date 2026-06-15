// sub_sections/flight_step_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/flight_controller.dart';
import '../modals/flight_filter_bottom_sheet.dart';
import '../section/flight_result_screen/selected_flight_ticket_section.dart';
import '../section/flight_result_screen/ticket_flight_section.dart';
import '../widgets/flight_result_card/button_continue.dart';

class FlightStepSelector extends StatelessWidget {
  final VoidCallback onContinue;

  const FlightStepSelector({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<FlightController>();
    final state = controller.state;
    final data = state.data;

    // Logic xác định nhãn tiêu đề
    final depLabel = state.ui.isViewingReturnFlights
        ? state.criteria.destinationAirport.desc
        : state.criteria.departureAirport.desc;
    final desLabel = state.ui.isViewingReturnFlights
        ? state.criteria.departureAirport.desc
        : state.criteria.destinationAirport.desc;

    return Column(
      children: [
        // 1. Nút Bộ lọc (Chỉ hiện khi chưa chọn đủ hoặc đang xem danh sách)
        if (!state.ui.isLoading && _shouldShowFlightList(state))
          _buildFilterButton(context, l10n),

        // 2. Các vé đã chọn (Giỏ hàng)
        _buildSelectedTickets(data),

        // 3. Danh sách vé để chọn
        if (_shouldShowFlightList(state)) ...[
          _buildListHeader(context, l10n, depLabel ?? '', desLabel ?? ''),
          state.ui.isLoading
              ? const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: kPrimaryColor),
          ))
              : TicketFlightSection(isViewingReturn: state.ui.isViewingReturnFlights), // Component hiển thị danh sách
        ],

        // 4. Nút Tiếp tục (Chỉ hiện khi đã chọn đủ vé)
        if (_isSelectionComplete(state))
          Padding(
            padding: EdgeInsets.all(context.padding),
            child: ContinueButton(onPressed: onContinue),
          ),
      ],
    );
  }

  // --- Logic Helpers ---
  bool _isSelectionComplete(dynamic state) {
    final data = state.data;
    if (data.internationalFlights.isNotEmpty) return data.selectedInternationalFlight != null;
    bool outboundPicked = data.selectedOutboundFlight != null;
    bool returnPicked = data.selectedReturnFlight != null;
    return state.criteria.roundTrip ? (outboundPicked && returnPicked) : outboundPicked;
  }

  bool _shouldShowFlightList(dynamic state) {
    final data = state.data;
    if (data.internationalFlights.isNotEmpty) return data.selectedInternationalFlight == null;
    if (data.selectedOutboundFlight == null) return true;
    if (state.criteria.roundTrip && data.selectedReturnFlight == null) return true;
    return false;
  }

  // --- UI Components ---
  Widget _buildFilterButton(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: InkWell(
        onTap: () => showFlightFilter(context),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tune_rounded, size: 20),
              SizedBox(width: 8),
              Text(l10n.filter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTickets(dynamic data) {
    return Column(
      children: [
        if (data.selectedInternationalFlight != null)
          SelectedFlightTicketSection(intlPair: data.selectedInternationalFlight, isOutbound: true),
        if (data.selectedInternationalFlight == null) ...[
          if (data.selectedOutboundFlight != null)
            SelectedFlightTicketSection(
              flight: data.outboundFlights.firstWhere((item) => item.go == data.selectedOutboundFlight),
              inventory: data.selectedOutboundInventory,
              isOutbound: true,
            ),
          if (data.selectedReturnFlight != null)
            SelectedFlightTicketSection(
              flight: data.returnFlights.firstWhere((item) => item.go == data.selectedReturnFlight),
              inventory: data.selectedReturnInventory,
              isOutbound: false,
            ),
        ],
      ],
    );
  }

  Widget _buildListHeader(BuildContext context, AppLocalizations l10n, String dep, String des) {
    return Align(
      alignment: Alignment.centerLeft, // Đảm bảo text luôn nằm bên trái
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.padding, // Sử dụng padding chuẩn của ứng dụng
          vertical: 16, // Khoảng cách trên dưới (giảm từ 24 xuống 16 cho gọn)
        ),
        child: Text(
          l10n.flight_from_to(dep, des),
          style: TextStyle(
            fontSize: context.sp(16),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).copyWith(
            // Bạn có thể chỉnh thêm chiều cao dòng nếu cần
            height: 1.2,
          ),
        ),
      ),
    );
  }
}