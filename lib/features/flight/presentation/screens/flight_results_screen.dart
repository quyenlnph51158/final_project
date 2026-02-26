import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:final_project/features/flight/data/models/inventory.dart';
import 'package:final_project/features/flight/data/service/flight_service.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';

// =============================================================================
//                             0. MOCK DATA & CONSTANTS
// =============================================================================



// ======================= CÁC LỚP DỮ LIỆU MẪU (BỔ SUNG) =======================
// ======================= WIDGET TỔNG QUAN CHUYẾN BAY (STATEFUL) =======================
class FlightResultsScreen extends StatefulWidget {
  final String departureCode;
  final String destinationCode;
  final String departureDate;
  final String returnDate;
  final int adults;
  final int children;
  final int infant;
  final bool isRoundTrip;

  const FlightResultsScreen({
    super.key,
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
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      context.read<FlightController>().fetchFlights(l10n, widget.departureCode, widget.destinationCode, widget.departureDate, widget.returnDate, widget.adults, widget.children, widget.infant);

    }); // Lần đầu chỉ tải chuyến đi
  }



  // ----------------------- 1. HEADER THÔNG TIN CHUYẾN ĐI -----------------------

  Widget _buildFlightInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state=context.watch<FlightController>().state;
    // Điều chỉnh thông tin hiển thị dựa trên trạng thái
    final String currentDeparture = state.isViewingReturnFlights ? widget.destinationCode : widget.departureCode;
    final String currentDestination = state.isViewingReturnFlights ? widget.departureCode : widget.destinationCode;
    final String currentDate = state.isViewingReturnFlights ? widget.returnDate : widget.departureDate;
    final String tripType = state.isViewingReturnFlights ? l10n.flight_results_return : l10n.flight_results_outbound;

    final currentResults = state.currentFlightResults ?? [];
    final int resultCount = currentResults.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      color: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Hiển thị trạng thái chuyến đi
          if (widget.isRoundTrip)
            Text(
              tripType,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          Text(
            '$currentDeparture - $currentDestination',
            style: const TextStyle(
              color: kTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: kTextColor),
              const SizedBox(width: 8),
              Text(
                l10n.flight_resultFlightDate(currentDate),
                style: const TextStyle(color: kTextColor, fontSize: 15),
              ),
            ],
          ),
          // Hiển thị chuyến bay chiều đi đã chọn nếu đang xem chuyến về
          if (state.selectedOutboundFlight != null && state.isViewingReturnFlights)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                l10n.flight_results_selected_outbound(state.selectedOutboundFlight!.flightCode,DateFormat('HH:mm').format(DateTime.parse(state.selectedOutboundFlight!.departureDate))),
                style: TextStyle(color: kTextColor.withOpacity(0.9), fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            l10n.flight_results_found_count(resultCount),
            style: TextStyle(color: kTextColor.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ----------------------- 3. WIDGET CARD KẾT QUẢ CHUYẾN BAY (ĐÃ ĐIỀU CHỈNH) -----------------------
  Widget _buildFlightList() {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<FlightController>().state;
    final displayResults = state.currentFlightResults ?? [];
    final controller=context.read<FlightController>();

    if (displayResults.isEmpty) {
      return Center(child: Text(l10n.flight_noFlightsFound));
    }

    return ListView.builder(
      controller: controller.scrollController,
      itemCount: displayResults.length,
      itemBuilder: (context, index) {
        final currentFlight = displayResults[index];
        return FlightResultCard(flight: currentFlight,);
      },
    );
  }
  // ----------------------- 4. BUILD METHOD CHÍNH -----------------------

  @override
  Widget build(BuildContext context) {
    final controller= context.read<FlightController>();
    final state=context.watch<FlightController>().state;
    final l10n = AppLocalizations.of(context)!;
    // Điều chỉnh tiêu đề App Bar
    final String appBarTitle = widget.isRoundTrip && state.isViewingReturnFlights
        ? l10n.flight_selectReturnFlight
        : l10n.form_consultation_app_title_mock;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: kBackgroundColor,
        foregroundColor: kTextColor,
        // Thêm nút quay lại danh sách chuyến đi
        leading: widget.isRoundTrip && state.isViewingReturnFlights
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.backToOutboundFlights();
          },
        )
            : null,
      ),
      body: Column(
        children: [
          _buildFlightInfo(context),
          Expanded(
            child: state.isLoading
                ? const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ) : _buildFlightList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------- 5. WIDGET TEST CHẠY ỨNG DỤNG ----------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: l10n.form_consultation_app_title_mock,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        useMaterial3: true,
      ),
      home: const FlightResultsScreen(),
    );
  }
}