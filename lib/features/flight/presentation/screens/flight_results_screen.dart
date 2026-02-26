import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_result_card/flight_result_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import 'package:dotted_line/dotted_line.dart';

// =============================================================================
//                             0. MOCK DATA & CONSTANTS
// =============================================================================



// ======================= CÁC LỚP DỮ LIỆU MẪU (BỔ SUNG) =======================
// ======================= WIDGET TỔNG QUAN CHUYẾN BAY (STATEFUL) =======================
class FlightResultsScreen extends StatefulWidget {
  final String departure;
  final String destination;
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
    this.departure = 'Hà Nội',
    this.destination = 'Hồ Chí Minh',
    this.departureCode = 'HAN',
    this.destinationCode = 'SGN',
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
    final String currentDeparture = state.isViewingReturnFlights ? widget.destination : widget.departure;
    final String currentDestination = state.isViewingReturnFlights ? widget.departure : widget.destination;
    final String currentDepartureCode = state.isViewingReturnFlights ? widget.destinationCode : widget.departureCode;
    final String currentDestinationCode = state.isViewingReturnFlights ? widget.departureCode : widget.destinationCode;
    final String departureDate = widget.departureDate;
    final String returnDate = widget.returnDate;
    return Column(
      children: [
        Container(
          width: 393,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              Container(
                width: 361,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 28,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Container(
                            width: 361,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 9,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 16,
                                    children: [
                                      Text(
                                        currentDepartureCode,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF01171B) /* Color-950 */,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            /// ---- CHUYẾN ĐI ----
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 1,
                                                    child: DottedLine(
                                                      dashLength: 6,
                                                      dashGapLength: 4,
                                                      lineThickness: 1,
                                                      dashColor: Colors.teal,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                const Icon(
                                                  Icons.flight,
                                                  color: Colors.teal,
                                                  size: 18,
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 6),

                                            /// ---- CHUYẾN VỀ ----
                                            if(state.roundTrip == true )
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.flight,
                                                    color: Colors.teal,
                                                    size: 18,
                                                ),

                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 1,
                                                    child: DottedLine(
                                                      dashLength: 6,
                                                      dashGapLength: 4,
                                                      lineThickness: 1,
                                                      dashColor: Colors.teal,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        currentDestinationCode,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF01171B) /* Color-950 */,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 178,
                                    children: [
                                      SizedBox(
                                        width: 55,
                                        child: Text(
                                          currentDeparture,
                                          style: TextStyle(
                                            color: const Color(0xFF555F65) /* Color-600 */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        currentDestination,
                                        style: TextStyle(
                                          color: const Color(0xFF555F65) /* Color-600 */,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 50,
                              children: [
                                Container(
                                  width: 94,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4,
                                    children: [
                                      SizedBox(
                                        width: 94,
                                        child: Text(
                                          'Khởi hành',
                                          style: TextStyle(
                                            color: const Color(0xFF01171B) /* Color-950 */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 94,
                                        child: Text(
                                          departureDate,
                                          style: TextStyle(
                                            color: const Color(0xFF01171B) /* Color-950 */,
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 94,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4,
                                    children: [
                                      SizedBox(
                                        width: 94,
                                        child: Text(
                                          'Trở về',
                                          style: TextStyle(
                                            color: const Color(0xFF01171B) /* Color-950 */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 94,
                                        child: Text(
                                          returnDate,
                                          style: TextStyle(
                                            color: const Color(0xFF01171B) /* Color-950 */,
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: [
                                SizedBox(
                                  width: 361,
                                  child: Text(
                                    'Hành khách',
                                    style: TextStyle(
                                      color: const Color(0xFF01171B) /* Color-950 */,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 361,
                                  child: Text(
                                    '1 Người lớn',
                                    style: TextStyle(
                                      color: const Color(0xFF01171B) /* Color-950 */,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 361,
                      child: Text(
                        'Thay đổi',
                        style: TextStyle(
                          color: const Color(0xFF006C81) /* Primary */,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E7E9) /* Color-100 */,
                ),
              ),
            ],
          ),
        ),
      ],
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
