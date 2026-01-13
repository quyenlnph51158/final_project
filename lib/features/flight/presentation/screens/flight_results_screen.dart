import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:final_project/features/flight/data/models/inventory.dart';
import 'package:final_project/features/flight/data/service/flight_service.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

// =============================================================================
//                             0. MOCK DATA & CONSTANTS
// =============================================================================

// --- MOCK CONSTANTS ---
const Color kPrimaryColorr = Color(0xFF007BFF);
const Color kSidebarDividerColorr = Color(0xFFE0E0E0);
const Color kHeaderTextColorr = Colors.white;
const Color kHeaderBackgroundColorr = Color(0xFF2C3E50);

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
  String? _errorMessage;
  final FlightService _flightService = FlightService();
  // Đổi tên để chứa kết quả hiện tại đang hiển thị (Chiều đi hoặc Chiều về)
  List<FlightInfo>? _currentFlightResults;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  // THÊM BIẾN STATE MỚI
  FlightInfo? _selectedOutboundFlight; // Chuyến bay chiều đi đã chọn
  bool _isViewingReturnFlights = false; // Đang xem danh sách chuyến về
  // Kết quả chuyến bay chiều đi
  List<FlightInfo>? _outboundFlights;
  // Kết quả chuyến bay chiều về
  List<FlightInfo>? _returnFlights;

  @override
  void initState() {
    super.initState();
    _fetchOutboundFlightData(); // Lần đầu chỉ tải chuyến đi
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _extractAirportCode(String fullAirportString) {
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(fullAirportString);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return fullAirportString;
  }

  // Phương thức Tải chuyến bay chiều đi (OUTBOUND)
  Future<void> _fetchOutboundFlightData() async {
    final l10n = AppLocalizations.of(context)!;
    final String startCode = _extractAirportCode(widget.departureCode);
    final String endCode = _extractAirportCode(widget.destinationCode);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Giả định typeAirport=2 cho chuyến đi (một chiều) hoặc bạn có thể điều chỉnh logic API
      final listAirport = await _flightService.fetchFLightInfo(
          startAirport: startCode,
          endAirport: endCode,
          startDate: widget.departureDate,
          returnDate: widget.returnDate, // Dù không dùng nhưng vẫn truyền
          adults: widget.adults,
          children: widget.children,
          infant: widget.infant,
          typeAirport: widget.isRoundTrip ? 2 : 1 // 2 có thể là một chiều đi
      );
      setState(() {
        _outboundFlights = listAirport;
        _currentFlightResults = _outboundFlights; // Hiển thị chuyến đi
        _isLoading = false;
        _errorMessage = null;
        _isViewingReturnFlights = false;
      });
      if(_currentFlightResults != null) {
        print('Danh sách chuyến đi không trống');
      }
    } catch (e) {
      print('LỖI KHI TẢI LIST OUTBOUND AIRPORT: $e');
      setState(() {
        _errorMessage = '${l10n.error_flightOutboundDataLoadingFailed} $e';
        _isLoading = false;
        _isViewingReturnFlights = false;
      });
    }
  }

  // Phương thức Tải chuyến bay chiều về (RETURN)
  Future<void> _fetchReturnFlightData() async {
    final l10n = AppLocalizations.of(context)!;
    final String startCode = _extractAirportCode(widget.destinationCode);
    final String endCode = _extractAirportCode(widget.departureCode);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentFlightResults = null; // Xóa kết quả cũ
    });

    try {
      // Giả định typeAirport=2 cho chuyến về
      final listAirport = await _flightService.fetchFLightInfo(
          startAirport: startCode,
          endAirport: endCode,
          startDate: widget.returnDate, // Ngày về
          returnDate: '', // Không cần thiết cho chuyến về
          adults: widget.adults,
          children: widget.children,
          infant: widget.infant,
          typeAirport: 2 // Có thể là một chiều về
      );
      setState(() {
        _returnFlights = listAirport;
        _currentFlightResults = _returnFlights; // Hiển thị chuyến về
        _isLoading = false;
        _errorMessage = null;
        _isViewingReturnFlights = true;
      });
      if(_currentFlightResults != null) {
        print('Danh sách chuyến về không trống');
      }
    } catch (e) {
      print('LỖI KHI TẢI LIST RETURN AIRPORT: $e');
      setState(() {
        _errorMessage = '${l10n.error_flightReturnDataLoadingFailed} $e';
        _isLoading = false;
        _isViewingReturnFlights = true;
      });
    }
  }

  // Xử lý khi chọn chuyến bay
  void _selectFlight(FlightInfo flight, Inventory selectedInventory) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.isRoundTrip && !_isViewingReturnFlights) {
      // Bước 1: Chọn chuyến đi (Outbound)
      setState(() {
        _selectedOutboundFlight = flight;
      });
      // Tải và hiển thị chuyến bay chiều về
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.flight_results_selecting_return(flight.flightCode))),
      );
      _fetchReturnFlightData(); // Tải chuyến bay chiều về
    } else {
      // Bước 2: Chọn chuyến về (Return) hoặc chuyến một chiều
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.flight_results_selected_final(widget.isRoundTrip,flight.flightCode,selectedInventory.seatClass))),
      );
      // TODO: Thêm logic điều hướng đến trang đặt vé cuối cùng, truyền cả _selectedOutboundFlight và flight hiện tại
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // ----------------------- 1. HEADER THÔNG TIN CHUYẾN ĐI -----------------------

  Widget _buildTripInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Điều chỉnh thông tin hiển thị dựa trên trạng thái
    final String currentDeparture = _isViewingReturnFlights ? widget.destinationCode : widget.departureCode;
    final String currentDestination = _isViewingReturnFlights ? widget.departureCode : widget.destinationCode;
    final String currentDate = _isViewingReturnFlights ? widget.returnDate : widget.departureDate;
    final String tripType = _isViewingReturnFlights ? l10n.flight_results_return : l10n.flight_results_outbound;

    final currentResults = _currentFlightResults ?? [];
    final int resultCount = currentResults.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      color: kHeaderBackgroundColorr,
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
              color: kHeaderTextColorr,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: kHeaderTextColorr),
              const SizedBox(width: 8),
              Text(
                l10n.flight_resultFlightDate(currentDate),
                style: const TextStyle(color: kHeaderTextColorr, fontSize: 15),
              ),
            ],
          ),
          // Hiển thị chuyến bay chiều đi đã chọn nếu đang xem chuyến về
          if (_selectedOutboundFlight != null && _isViewingReturnFlights)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                l10n.flight_results_selected_outbound(_selectedOutboundFlight!.flightCode,DateFormat('HH:mm').format(DateTime.parse(_selectedOutboundFlight!.departureDate))),
                style: TextStyle(color: kHeaderTextColorr.withOpacity(0.9), fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            l10n.flight_results_found_count(resultCount),
            style: TextStyle(color: kHeaderTextColorr.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ... (Giữ nguyên các widget phụ khác: _buildFeatureRow, _formatDuration, _buildTimeAndAirport)

  // ----------------------- 3. WIDGET CARD KẾT QUẢ CHUYẾN BAY -----------------------
  String _formatDuration(int minutes) {
    final l10n = AppLocalizations.of(context)!;
    if (minutes < 60) {
      return l10n.flight_results_duration_min(minutes);
    }
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return l10n.flight_results_duration_hour(hours,remainingMinutes);
  }
  // ----------------------- 3. WIDGET CARD KẾT QUẢ CHUYẾN BAY (ĐÃ ĐIỀU CHỈNH) -----------------------
  Widget _buildFlightList() {
    final l10n = AppLocalizations.of(context)!;
    final displayResults = _currentFlightResults ?? [];

    if (displayResults.isEmpty) {
      return Center(child: Text(l10n.flight_noFlightsFound));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: displayResults.length,
      itemBuilder: (context, index) {
        final currentFlight = displayResults[index];
        return _buildFlightResultCard(context, currentFlight);
      },
    );
  }
  Widget _buildFlightResultCard(BuildContext context, FlightInfo flight) {
    final l10n = AppLocalizations.of(context)!;
    final String departureTime = DateFormat('HH:mm').format(DateTime.parse(flight.departureDate));
    final String arrivalTime = DateFormat('HH:mm').format(DateTime.parse(flight.arrivalDate));
    final String airportFrom = flight.departureCode;
    final String airportTo = flight.arrivalCode;
    final String duration = _formatDuration(flight.totalDuration);
    final String totalStopsText = flight.stopNo == 0 ? l10n.flight_directFlight : '${flight.stopNo} ${l10n.flight_stopNo}';
    final Color stopColor = flight.stopNo == 0 ? kPrimaryColorr : Colors.orange;
    final String airlineLogoUrl = flight.logo;
    bool isExpanded = false;
    Inventory _selectedInventory = flight.inventories.first;

    return StatefulBuilder(
      builder: (context, setState) {
        final String price = NumberFormat('#,###').format(_selectedInventory.totalPrice);
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
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.airplanemode_active, color: kPrimaryColorr),
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
                            const Icon(Icons.arrow_right_alt, color: kPrimaryColorr),
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
                            icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryColorr),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black87),
                            underline: Container(
                              height: 1,
                              color: kPrimaryColorr,
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

                    const Divider(height: 25, color: kSidebarDividerColorr),
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
                              _selectFlight(flight, _selectedInventory);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColorr,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              // ĐỔI TEXT TÙY THEO TRẠNG THÁI
                              _isViewingReturnFlights ? l10n.flight_selectReturnTicket : l10n.flight_selectOutboundTicket,
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
                                color: kPrimaryColorr,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: kPrimaryColorr,
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
                            return _buildFeatureRow(feature);
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

  Widget _buildFeatureRow(String text) {
    final l10n = AppLocalizations.of(context)!;
    IconData icon;
    Color color;

    if (text.contains(l10n.flight_luggage)) {
      icon = Icons.luggage_outlined;
      color = Colors.grey.shade600;
    } else if (text.contains(l10n.flight_change)) {
      icon = Icons.swap_horiz;
      color = kPrimaryColorr;
    } else if (text.contains(l10n.flight_returnTicket)) {
      icon = Icons.cancel_outlined;
      color = Colors.red.shade700;
    } else {
      icon = Icons.check_circle_outline;
      color = kPrimaryColorr;
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


  // ----------------------- 4. BUILD METHOD CHÍNH -----------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Điều chỉnh tiêu đề App Bar
    final String appBarTitle = widget.isRoundTrip && _isViewingReturnFlights
        ? l10n.flight_selectReturnFlight
        : l10n.form_consultation_app_title_mock;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: kHeaderBackgroundColorr,
        foregroundColor: kHeaderTextColorr,
        // Thêm nút quay lại danh sách chuyến đi
        leading: widget.isRoundTrip && _isViewingReturnFlights
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isViewingReturnFlights = false;
              _currentFlightResults = _outboundFlights;
              _selectedOutboundFlight = null;
            });
            _scrollToTop();
          },
        )
            : null,
      ),
      body: Column(
        children: [
          _buildTripInfo(context),
          Expanded(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(color: kPrimaryColorr),
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
        primaryColor: kPrimaryColorr,
        useMaterial3: true,
      ),
      home: const FlightResultsScreen(),
    );
  }
}