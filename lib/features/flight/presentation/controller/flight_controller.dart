import 'package:final_project/features/flight/data/models/flight_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/flight/data/models/list_airport.dart';
import 'package:final_project/features/flight/data/models/list_cheap_flight.dart';
import 'package:final_project/features/flight/data/service/listairport_service.dart';
import 'package:final_project/features/flight/data/service/listcheapflight_service.dart';
import 'package:final_project/features/flight/presentation/state/flight_state.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../data/service/flight_service.dart';
import '../screens/flight_results_screen.dart';
import 'package:intl/intl.dart';

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
  Future<void> initData(
      ) async {
    if (_state.isInitialized) return;

    _updateState(
      _state.copyWith(
        isLoading: true,
      ),
    );

    try {
      final results = await Future.wait([
        _cheapFlightService.fetchlistcheapflight(),
        _airportService.fetchListAirport(),
      ]);

      _updateState(
        _state.copyWith(
          listCheapFlight:
          results[0] as List<ListCheapFlight>,
          listAirport:
          results[1] as List<ListAirport>,
          isLoading: false,
          isInitialized: true,
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
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
      String departureDate,
      String returnDate,
      int adults,
      int children,
      int infant,
      ) async {
    final startCode = extractAirportCode(departureCode);
    final endCode = extractAirportCode(destinationCode);

    _updateState(_state.copyWith(
      isLoading: true,
      errorMessage: null,
      isViewingReturnFlights: false,
    ));

    try {
      final response = await _flightService.fetchFlightInfo(
        startAirport: startCode,
        endAirport: endCode,
        startDate: departureDate,
        returnDate: returnDate,
        adults: adults,
        children: children,
        infant: infant,
        typeAirport: state.typeAirport,
      );
      final isRoundTrip = state.typeAirport == 2;

      _updateState(_state.copyWith(
        outboundFlights: response.outbound,
        returnFlights: isRoundTrip ? response.returnFlights : [],
        currentFlightResults: response.outbound,
        isLoading: false,
        isViewingReturnFlights: false,
      ));

      print('✅ Outbound: ${response.outbound.length}');
      print('✅ Return: ${response.returnFlights.length}');
      print('✅ TypeAirport: ${state.typeAirport}');
    } catch (e) {
      _updateState(_state.copyWith(
        errorMessage: '${l10n.error_flightOutboundDataLoadingFailed} $e',
        isLoading: false,
      ));
    }
  }

  void backToOutboundFlights() {
    _updateState(
      state.copyWith(
        isViewingReturnFlights: false,
        currentFlightResults: state.outboundFlights,
        selectedOutboundFlight: null,
      ),
    );
    scrollToTop();
  }

  // ===== AIRPORT FILTER =====
  List<ListAirport> filteredAirports(
      String query,
      ) {
    final q = query.toLowerCase().trim();

    if (q.isEmpty) return _state.listAirport;

    return _state.listAirport.where((airport) {
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
          departureCode: airport.value,
          departure: '${airport.label} (${airport.value})',
        ),
      );
    } else {
      _updateState(
        _state.copyWith(
          destinationCode: airport.value,
          destination: '${airport.label} (${airport.value})'
        ),
      );
    }
  }

  void setDate({
    required bool isReturnDate,
    required String formattedDate,
  }) {
    _updateState(
      isReturnDate
          ? _state.copyWith(returnDate: formattedDate)
          : _state.copyWith(selectedDate: formattedDate),
    );
  }


  void updateTripType(bool isRoundTrip, AppLocalizations l10n) {
    _updateState(
      _state.copyWith(
        roundTrip: isRoundTrip,
        typeAirport: isRoundTrip ? 2 : 1,

        // 🔥 QUAN TRỌNG
        returnDate: isRoundTrip ? _state.returnDate : '',
        selectedReturnFlight: null,
        isViewingReturnFlights: false,

        outboundFlights: [],
        returnFlights: [],
        currentFlightResults: [],
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
        adultCount: adults,
        childCount: children,
        infantCount: infants,
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
    if (state.departureCode.isEmpty || state.destinationCode.isEmpty) {
      _updateState(
        state.copyWith(errorMessage: l10n.error_flightSearchMissingInput),
      );
      return;
    }

    _updateState(state.copyWith(isSearching: true, errorMessage: null));

    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FlightResultsScreen(
            departureCode: state.departureCode,
            destinationCode: state.destinationCode,
            departureDate: state.selectedDate,
            returnDate: state.returnDate.toString(),
            adults: state.adultCount,
            children: state.childCount,
            infant: state.infantCount,
            isRoundTrip: state.roundTrip,
          ),
        ),
      );
    } catch (e) {
      _updateState(
        state.copyWith(
          errorMessage: '${l10n.error_flightSearchConnectionFailed} $e',
        ),
      );
    } finally {
      _updateState(state.copyWith(isSearching: false));
    }
  }
  void selectFlightTab(
      FlightTab tab,
      AppLocalizations l10n,
      ) {
    // reset state chung
    _updateState(
      _state.copyWith(
        selectedFlightTab: tab,
        roundTrip: true,
        returnDate: '',
        errorMessage: null,
        departure: '',
        destination: '',
        departureCode: '',
        destinationCode: '',
      ),
    );
  }
  void selectOutboundFlight(FlightInfo flight) {
    _updateState(_state.copyWith(
      selectedOutboundFlight: flight,
      isViewingReturnFlights: true,
      currentFlightResults: _state.returnFlights,
    ));
  }

  void selectReturnFlight(FlightInfo flight) {
    _updateState(_state.copyWith(
      selectedReturnFlight: flight,
    ));
  }

  void setViewingReturnFlight(bool ViewingReturnFlights){
    _updateState(_state.copyWith(
      isViewingReturnFlights: ViewingReturnFlights
    ));
  }

  void departureCodeSelected(
      String departureCode,
      String arrivalCode,
      String departure,
      String destination,
      FlightTab tab,
      AppLocalizations l10n
      ) {
    selectFlightTab(tab, l10n);

    _updateState(
      _state.copyWith(
        departureCode: departureCode,
        destinationCode: arrivalCode,
        departure: departure + ' ( ${departureCode})',
        destination: destination + ' ( ${arrivalCode})',
      ),
    );
    scrollToTop();
  }

  void updateTab(FlightTab tab) {
    _state = _state.copyWith(selectedFlightTab: tab, isSearching: false);
    notifyListeners();
  }

  void resetSearch() {
    _state = _state.copyWith(isSearching: false, );
    notifyListeners();
  }
  void resetToInitial() {
    _state = FlightState.initial();

    notifyListeners();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
