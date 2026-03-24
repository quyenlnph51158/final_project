import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:final_project/features/flight/data/models/inventory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/flight/data/models/list_airport.dart';
import 'package:final_project/features/flight/data/models/list_cheap_flight.dart';
import 'package:final_project/features/flight/data/service/listairport_service.dart';
import 'package:final_project/features/flight/data/service/listcheapflight_service.dart';
import 'package:final_project/features/flight/presentation/state/flight_state.dart';
import 'package:intl/date_symbols.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/international_flight_pair.dart';
import '../../data/service/flight_service.dart';
import '../screens/flight_results_screen.dart';

class FlightController extends ChangeNotifier {
  FlightState _state = FlightState.initial();

  FlightState get state => _state;

  // ===== Services =====
  final ListcheapflightService _cheapFlightService = ListcheapflightService();
  final ListAirportService _airportService = ListAirportService();
  final FlightService _flightService = FlightService();

  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0, // Vị trí 0.0 là đầu trang
        duration: const Duration(milliseconds: 500), // Thời gian cuộn
        curve: Curves.easeInOut, // Hiệu ứng cuộn mượt mà
      );
    }
  }

  void scrollToForm(double headerHeight) {
    final double targetScrollPosition = headerHeight - 10;

    scrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // ===== INIT =====
  Future<void> initData() async {
    if (_state.ui.isInitialized) return;

    _updateState(_state.copyWith(ui: _state.ui.copyWith(isLoading: true)));

    try {
      final results = await Future.wait([
        _cheapFlightService.fetchlistcheapflight(),
        _airportService.fetchListAirport(),
      ]);

      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            listCheapFlight: results[0] as List<ListCheapFlight>,
            listAirport: results[1] as List<ListAirport>,
          ),
          ui: _state.ui.copyWith(isLoading: false, isInitialized: true),
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(isLoading: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  String extractAirportCode(String fullAirportString) {
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(fullAirportString);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return fullAirportString;
  }

  Future<void> fetchFlights(
    AppLocalizations l10n,
    String departureCode,
    String destinationCode,
    String? departureDate,
    String? returnDate,
    int adults,
    int children,
    int infant,
  ) async {
    final startCode = extractAirportCode(departureCode);
    final endCode = extractAirportCode(destinationCode);

    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(
          isLoading: true,
          errorMessage: null,
          isViewingReturnFlights: false,
        ),
      ),
    );

    try {
      final response = await _flightService.fetchFlightInfo(
        startAirport: startCode,
        endAirport: endCode,
        startDate: departureDate.toString(),
        returnDate: returnDate.toString(),
        adults: adults,
        children: children,
        infant: infant,
        typeAirport: state.criteria.typeAirport,
      );
      final isRoundTrip = state.criteria.typeAirport == 2;

      _updateState(
        _state.copyWith(
          data: _state.data.copyWith(
            internationalFlights: response.internationalPairs,
            originalInternationalFlights: response.internationalPairs,
            originalOutboundFlights: response.outboundFlights,
            originalReturnFlights: isRoundTrip ? response.returnFlights : [],
            outboundFlights: response.outboundFlights,
            returnFlights: isRoundTrip ? response.returnFlights : [],
          ),

          ui: _state.ui.copyWith(
            isLoading: false,
            isViewingReturnFlights: false,
          ),
        ),
      );
      print('count flight ticket ${state.data.outboundFlights}');
      print("STATE outbound length: ${_state.data.outboundFlights.length}");
      print("STATE return length: ${_state.data.returnFlights.length}");
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(
            errorMessage: '${l10n.error_flightOutboundDataLoadingFailed} $e',
            isLoading: false,
          ),
        ),
      );
    }
  }

  void backToSelectOutboundFlights() {
    _updateState(
      state.copyWith(
        ui: _state.ui.copyWith(
          isViewingReturnFlights: false,
          isSelectedOutboundFlight: false,
          isSelectedReturnFlight: false,
          isSelectedInternationalFlight: false,
        ),
        data: _state.data.copyWith(
          selectedInternationalFlight: null,
          selectedOutboundFlight: null,
          selectedOutboundInventory: null,
          selectedReturnFlight: null,
          selectedReturnInventory: null,
        ),
      ),
    );
    scrollToTop();
  }

  void backToSelectReturnFlights() {
    print("data return flight is deleted");
    _updateState(
      state.copyWith(
        ui: _state.ui.copyWith(
          isViewingReturnFlights: true,
          isSelectedReturnFlight: false,
        ),
        data: _state.data.copyWith(
          selectedReturnFlight: null,
          selectedReturnInventory: null,
        ),
      ),
    );
    scrollToTop();
  }

  // ===== AIRPORT FILTER =====
  List<ListAirport> filteredAirports(String query) {
    final q = query.toLowerCase().trim();

    if (q.isEmpty) return _state.data.listAirport;

    return _state.data.listAirport.where((airport) {
      final label = airport.label?.toLowerCase() ?? '';
      final value = airport.value?.toLowerCase() ?? '';
      return label.contains(q) || value.contains(q);
    }).toList();
  }

  // ===== SELECT AIRPORT =====
  void selectAirport({
    required bool isDeparture,
    required ListAirport airport,
  }) {
    if (isDeparture) {
      _updateState(
        _state.copyWith(
          criteria: _state.criteria.copyWith(
            departureCode: airport.value,
            departure: airport.desc,
          ),
        ),
      );
    } else {
      _updateState(
        _state.copyWith(
          criteria: _state.criteria.copyWith(
            destinationCode: airport.value,
            destination: airport.desc,
          ),
        ),
      );
    }
  }

  void setDate({required bool isReturnDate, required String formattedDate}) {
    _updateState(
      isReturnDate
          ? _state.copyWith(
              criteria: _state.criteria.copyWith(returnDate: formattedDate),
            )
          : _state.copyWith(
              criteria: _state.criteria.copyWith(departureDate: formattedDate),
            ),
    );
  }

  void updateTripType(bool isRoundTrip, AppLocalizations l10n) {
    _updateState(
      _state.copyWith(
        criteria: _state.criteria.copyWith(
          roundTrip: isRoundTrip,
          typeAirport: isRoundTrip ? 2 : 1,

          // 🔥 QUAN TRỌNG
          returnDate: isRoundTrip ? _state.criteria.returnDate : '',
        ),
        data: _state.data.copyWith(
          selectedReturnFlight: null,
          originalOutboundFlights: [],
          originalReturnFlights: [],
          outboundFlights: [],
          returnFlights: [],
          currentFlightResults: [],
        ),
        ui: _state.ui.copyWith(
          isViewingReturnFlights: isRoundTrip ? true : false,
        ),
      ),
    );
  }

  void updatePassengerData({
    required int adults,
    required int children,
    required int infants,
  }) {
    _updateState(
      _state.copyWith(
        criteria: _state.criteria.copyWith(
          adultCount: adults,
          childCount: children,
          infantCount: infants,
        ),
      ),
    );
  }

  // ===== INTERNAL =====
  void _updateState(FlightState newState) {
    _state = newState;
    notifyListeners();
  }

  void navigateToFlightResults(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (state.criteria.departureCode.isEmpty ||
        state.criteria.destinationCode.isEmpty) {
      _updateState(
        state.copyWith(
          ui: _state.ui.copyWith(
            errorMessage: l10n.error_flightSearchMissingInput,
          ),
        ),
      );
      return;
    }

    _updateState(
      state.copyWith(
        ui: _state.ui.copyWith(isSearching: true, errorMessage: null),
      ),
    );

    try {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => FlightResultsScreen()));
    } catch (e) {
      _updateState(
        state.copyWith(
          ui: _state.ui.copyWith(
            errorMessage: '${l10n.error_flightSearchConnectionFailed} $e',
          ),
        ),
      );
    } finally {
      _updateState(state.copyWith(ui: _state.ui.copyWith(isSearching: false)));
    }
  }

  void selectFlightTab(FlightTab tab, AppLocalizations l10n) {
    // reset state chung
    _updateState(
      _state.copyWith(
        criteria: _state.criteria.copyWith(
          roundTrip: true,
          returnDate: '',
          departure: '',
          destination: '',
          departureCode: '',
          destinationCode: '',
        ),
        ui: _state.ui.copyWith(selectedFlightTab: tab, errorMessage: null),
      ),
    );
  }

  void selectOutboundFlight(FlightInfo flight, Inventory inventory) {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          selectedOutboundFlight: flight,
          selectedOutboundInventory: inventory,
        ),
        ui: _state.ui.copyWith(
          isViewingReturnFlights: true,
          isSelectedOutboundFlight: true,
        ),
      ),
    );
  }

  void selectReturnFlight(FlightInfo flight, Inventory inventory) {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          selectedReturnFlight: flight,
          selectedReturnInventory: inventory,
        ),
        ui: _state.ui.copyWith(isSelectedReturnFlight: true),
      ),
    );
  }

  void selectInternationalPair(
    InternationalFlightPair pair, {
    int fareIndex = 0,
  }) {
    final selectedOutboundInven = pair.outbound.inventories[fareIndex];
    final selectedReturnInven = pair.returnFlight.inventories[fareIndex];

    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          // Lưu cả chặng đi và về vào các biến selected tương ứng
          selectedInternationalFlight: pair,
          selectedOutboundFlight: pair.outbound,
          selectedReturnFlight: pair.returnFlight,
          // Inventory cho vé quốc tế thường đi theo cặp
          selectedOutboundInventory: selectedOutboundInven,
          selectedReturnInventory: selectedReturnInven,
        ),
        ui: _state.ui.copyWith(
          // Đánh dấu là đã chọn xong cả 2 chiều
          isSelectedOutboundFlight: true,
          isSelectedReturnFlight: true,
          isSelectedInternationalFlight: true,
        ),
      ),
    );
  }

  void updateInternationalClassSelector(
    Inventory outboundInven,
    Inventory returnInven,
  ) {
    // Logic này tùy thuộc vào việc API của bạn trả về Inventory riêng lẻ
    // hay đi theo cặp cho vé quốc tế.
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          selectedOutboundInventory: outboundInven,
          selectedReturnInventory: returnInven,
        ),
      ),
    );
  }

  void updateOutboundFlightClassSelector(Inventory inven) {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(selectedOutboundInventory: inven),
      ),
    );
  }

  void updateReturnFlightClassSelector(Inventory inven) {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(selectedReturnInventory: inven),
      ),
    );
  }

  void departureCodeSelected(
    String departureCode,
    String arrivalCode,
    String departure,
    String destination,
    FlightTab tab,
    AppLocalizations l10n,
  ) {
    selectFlightTab(tab, l10n);

    _updateState(
      _state.copyWith(
        criteria: _state.criteria.copyWith(
          departureCode: departureCode,
          destinationCode: arrivalCode,
          departure: departure,
          destination: destination,
        ),
      ),
    );
    scrollToTop();
  }

  void updateTab(FlightTab tab) {
    _state = _state.copyWith(
      ui: _state.ui.copyWith(selectedFlightTab: tab, isSearching: false),
    );
    notifyListeners();
  }

  void resetSearch() {
    _updateState(_state.copyWith(ui: _state.ui.copyWith(isSearching: false)));
  }

  void resetToInitial() {
    _state = FlightState.initial();
    notifyListeners();
  }

  // Trong FlightController class

  void backToSearch() {
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          // Xóa danh sách chuyến bay và các lựa chọn
          originalOutboundFlights: [],
          originalReturnFlights: [],
          originalInternationalFlights: [],
          outboundFlights: [],
          returnFlights: [],
          internationalFlights: [],
          // THÊM DÒNG NÀY
          selectedInternationalFlight: null,
          selectedOutboundFlight: null,
          selectedOutboundInventory: null,
          selectedReturnFlight: null,
          selectedReturnInventory: null,
          currentFlightResults: [],
        ),
        ui: _state.ui.copyWith(
          isViewingReturnFlights: false,
          isLoading: false,
          errorMessage: null,
        ),
      ),
    );
  }

  void toggleAirlineSystem(String airlineSystem) {
    final currentSelected = List<String>.from(
      _state.filter.selectedAirlineSystem,
    );
    if (currentSelected.contains(airlineSystem)) {
      currentSelected.remove(airlineSystem);
    } else {
      currentSelected.add(airlineSystem);
    }
    _updateState(
      _state.copyWith(
        filter: _state.filter.copyWith(selectedAirlineSystem: currentSelected),
      ),
    );
  }

  void toggleStopPoint(int stop) {
    final currentSelected = List<int>.from(_state.filter.selectedStopPoint);
    if (currentSelected.contains(stop)) {
      currentSelected.remove(stop);
    } else {
      currentSelected.add(stop);
    }
    _updateState(
      _state.copyWith(
        filter: _state.filter.copyWith(selectedStopPoint: currentSelected),
      ),
    );
  }

  void toggleTimeDeparture(String time) {
    final currentSelected = List<String>.from(
      _state.filter.selectedTimeDeparture,
    );
    if (currentSelected.contains(time)) {
      currentSelected.remove(time);
    } else {
      currentSelected.add(time);
    }
    _updateState(
      _state.copyWith(
        filter: _state.filter.copyWith(selectedTimeDeparture: currentSelected),
      ),
    );
  }
  void applyFilter() {
    _updateState(
      _state.copyWith(ui: _state.ui.copyWith(isSearchingFlight: true)),
    );
    final filter = _state.filter;
    final data = _state.data;

    // --- 1. Lọc Outbound ---
    List<FlightInfo> filteredOutbound = data.originalOutboundFlights.where((
      flight,
    ) {
      List<String> timeStart = flight.timeStart.split(':');
      int hour = int.parse(timeStart[0]);
      bool matchAirline =
          filter.selectedAirlineSystem.isEmpty ||
          filter.selectedAirlineSystem.contains(flight.airlineSystemText);

      bool matchStop =
          filter.selectedStopPoint.isEmpty ||
          filter.selectedStopPoint.contains(flight.stopNo);
      bool matchTimeDeparture =
          filter.selectedTimeDeparture.isEmpty ||
          filter.selectedTimeDeparture.any((range) {
            switch (range) {
              case 'Sớm':
                return hour >= 0 && hour < 6;
              case 'Sáng':
                return hour >= 6 && hour < 12;
              case 'Trưa':
                return hour >= 12 && hour < 18;
              case 'Tối':
                return hour >= 18 && hour < 24;
              default:
                return false;
            }
          });

      return matchAirline &&
          matchStop &&
          matchTimeDeparture; // Phải thỏa mãn cả 2
    }).toList();

    // --- 2. Lọc Return ---
    List<FlightInfo> filteredReturn = data.originalReturnFlights.where((
      flight,
    ) {
      List<String> timeStart = flight.timeStart.split(':');
      int hour = int.parse(timeStart[0]);
      bool matchAirline =
          filter.selectedAirlineSystem.isEmpty ||
          filter.selectedAirlineSystem.contains(flight.airlineSystemText);

      bool matchStop =
          filter.selectedStopPoint.isEmpty ||
          filter.selectedStopPoint.contains(flight.stopNo);

      bool matchTimeDeparture =
          filter.selectedTimeDeparture.isEmpty ||
          filter.selectedTimeDeparture.any((range) {
            switch (range) {
              case 'Sớm':
                return hour >= 0 && hour < 6;
              case 'Sáng':
                return hour >= 6 && hour < 12;
              case 'Trưa':
                return hour >= 12 && hour < 18;
              case 'Tối':
                return hour >= 18 && hour < 24;
              default:
                return false;
            }
          });

      return matchAirline && matchStop && matchTimeDeparture;
    }).toList();

    // --- 3. Lọc International ---
    List<InternationalFlightPair> filteredInternational = data
        .originalInternationalFlights
        .where((pair) {
          List<String> outboundTimeStart = pair.outbound.timeStart.split(':');
          int hourOutbound = int.parse(outboundTimeStart[0]);
          // Kiểm tra hãng (Cả đi và về)
          bool matchAirline =
              filter.selectedAirlineSystem.isEmpty ||
              (filter.selectedAirlineSystem.contains(
                    pair.outbound.airlineSystemText,
                  ) &&
                  filter.selectedAirlineSystem.contains(
                    pair.returnFlight.airlineSystemText,
                  ));

          // Kiểm tra chặng dừng (Cả đi và về)
          bool matchStop =
              filter.selectedStopPoint.isEmpty ||
              (filter.selectedStopPoint.contains(pair.outbound.stopNo) &&
                  filter.selectedStopPoint.contains(pair.returnFlight.stopNo));

          bool isWithinRange(int hour, String range) {
            switch (range) {
              case 'Sớm':
                return hour >= 0 && hour < 6;
              case 'Sáng':
                return hour >= 6 && hour < 12;
              case 'Trưa':
                return hour >= 12 && hour < 18;
              case 'Tối':
                return hour >= 18 && hour < 24;
              default:
                return false;
            }
          }

          bool matchTimeDeparture =
              filter.selectedTimeDeparture.isEmpty ||
              (filter.selectedTimeDeparture.any(
                    (r) => isWithinRange(hourOutbound, r)));

          return matchAirline && matchStop && matchTimeDeparture;
        })
        .toList();

    // --- 4. Cập nhật State 1 lần duy nhất ---
    _updateState(
      _state.copyWith(
        data: _state.data.copyWith(
          outboundFlights: filteredOutbound,
          returnFlights: filteredReturn,
          internationalFlights: filteredInternational,
        ),
        ui: _state.ui.copyWith(isSearchingFlight: false),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
