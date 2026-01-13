import 'package:final_project/features/tour/data/models/location_item.dart';
import 'package:final_project/features/tour/data/service/tourdetail_service.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/features/flight/data/models/list_airport.dart';
import 'package:final_project/features/flight/data/service/listairport_service.dart';
import 'package:final_project/features/tour/data/models/tour_destination.dart';
import 'package:final_project/features/tour/data/service/api_service.dart';
import 'package:final_project/features/tour/data/service/tour_service.dart';
import 'package:final_project/features/tour/data/service/category_service.dart';
import 'package:final_project/features/tour/data/models/tour_item.dart';
import 'package:final_project/features/tour/data/models/tour_category.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../../../flight/presentation/screens/flight_results_screen.dart';
import '../../../data/models/tour_detail.dart';
import '../state/travel_booking_state.dart';
import '../tour_detail_screen.dart';

class TravelBookingController extends ChangeNotifier {
  TravelBookingState _state = TravelBookingState.initial();
  TravelBookingState get state => _state;

  final ListAirportService _airportService = ListAirportService();
  final TourService _tourService = TourService();
  final CategoryService _categoryService = CategoryService();
  final ApiService _apiService = ApiService();
  final TourdetailService _tourDetailService =TourdetailService();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController departureController = TextEditingController();
  final ScrollController scrollController = ScrollController();


  List<TourItem> get currentTours {
    final start = (state.currentPage - 1) * state.pageSize;
    final end = start + state.pageSize;

    return state.tourList.sublist(
      start,
      end > state.tourList.length ? state.tourList.length : end,
    );
  }
  double calculateAverageRating(List<dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;
    final totalRating = reviews.fold(0.0, (sum, item) {
      return sum + (double.tryParse((item.rating as num?)?.toString() ?? '0.0') ?? 0.0);
    });
    return totalRating / reviews.length;
  }
  int get totalPages => (state.tourList.length / state.pageSize).ceil();

  Future<void> initData(String defaultDeparture, String defaultDestination) async {
    if (_state.isInitialized) return;

    departureController.text = defaultDeparture;
    destinationController.text = defaultDestination;

    _setupTextFieldListeners();

    _updateState(
      _state.copyWith(
        isLoading: true,
        departure: defaultDeparture,
        destination: defaultDestination,
      ),
    );

    try {
      final results = await Future.wait([
        _airportService.fetchListAirport(),
        _tourService.fetchTours(),
        _categoryService.fetchTourCategories(),
        _apiService.fetchTourDestinations(),
      ]);

      _updateState(_state.copyWith(
        listAirport: results[0] as List<ListAirport>,
        tourList: results[1] as List<TourItem>,
        initialList: results[1] as List<TourItem>,
        tourCategories: results[2] as List<TourCategory>,
        tourDestinations: results[3] as List<TourDestination>,
        isLoading: false,
        isInitialized: true,
      ));
    } catch (e) {
      debugPrint("Error fetching booking data: $e");
      _updateState(_state.copyWith(isLoading: false));
    }
  }
  Future<void> fetchTourDetail(String name, String error) async{
    final String q = name ;
    _updateState(
        _state.copyWith(
            isLoading: true,
            errorMessage: null
        )
    );

    try{
      final TourDetail detail = await _tourDetailService.fetchTourDetail(q: q);
      _updateState(
          _state.copyWith(
            tourDetail: detail,
            isLoading: false,
            errorMessage: null,

          )
      );

    } catch(e){
      _updateState(
          _state.copyWith(
              errorMessage: '${error} $e',
              isLoading: false
          )
      );
    }
  }

  void loadTourPage(int page) {
    _updateState(
      state.copyWith(
        currentPage: page,
        isTourListLoading: false,
      ),
    );
  }


  void _setupTextFieldListeners() {
    departureController.addListener(() {
      if (departureController.text != _state.departure) {
        _state = _state.copyWith(departure: departureController.text);
        notifyListeners();
      }
    });

    destinationController.addListener(() {
      if (destinationController.text != _state.tempDestination) {
        _state = _state.copyWith(
            tempDestination: destinationController.text
        );
        notifyListeners();
      }
    });
  }
  void nextPage() {
    if (state.currentPage < totalPages) {
      _updateState(
        state.copyWith(isTourListLoading: true),
      );

      loadTourPage(state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 1) {
      _updateState(
        state.copyWith(isTourListLoading: true),
      );

      loadTourPage(state.currentPage - 1);
    }
  }




  void changeTab(TravelTab tab, AppLocalizations l10n) {
    final depText = tab == TravelTab.flight
        ? l10n.form_labelFlightDeparture
        : l10n.form_defaultDeparture;

    final destText = tab == TravelTab.flight
        ? l10n.form_labelFlightArrival
        : l10n.form_defaultDestination;

    departureController.text = depText;
    destinationController.text = destText;

    _state = _state.copyWith(
      selectedTab: tab,
      isSearching: false,
      departure: depText,
      destination: destText,
      returnDate: l10n.form_defaultReturnDate,
      tourList: state.initialList,
      isRoundTrip: true,
    );

    notifyListeners();
  }

  void updateDeparture(String label, String code) {
    departureController.text = label;
    _updateState(_state.copyWith(departure: label, departureCode: code));
  }

  void updateDestination(String label, String code) {
    _updateState(_state.copyWith(destination: label, arrivalCode: code));
  }

  void updatePassengers({
    int? adults,
    int? children,
    int? infants,
    String? ticketClass,
  }) {
    _updateState(_state.copyWith(
      adultCount: adults,
      childCount: children,
      infantCount: infants,
      selectedClass: ticketClass,
    ));
  }

  void _updateState(TravelBookingState newState) {
    _state = newState;
    notifyListeners();
  }

  List<LocationItem> getFilteredLocations(
      String query,
      bool isDeparture,
      ) {
    final otherValue =
    isDeparture ? _state.destination : _state.departure;

    if (_state.selectedTab == TravelTab.flight) {
      return _state.listAirport
          .where((a) {
        final label = '${a.label} (${a.value})';
        return label.toLowerCase().contains(query.toLowerCase()) &&
            label != otherValue;
      })
          .map(
            (a) => LocationItem(
          label: '${a.label} (${a.value})',
          code: a.value ?? '',
        ),
      )
          .toList();
    }

    return _state.tourDestinations
        .where((d) {
      final name = d.label ?? '';
      return name.toLowerCase().contains(query.toLowerCase()) &&
          name != otherValue;
    })
        .map(
          (d) => LocationItem(label: d.label ?? '', code: ''),
    )
        .toList();
  }

  void selectLocation(dynamic item, bool isDeparture) {
    if (isDeparture) {
      departureController.text = item.label;
      _state =
          _state.copyWith(departure: item.label, departureCode: item.code);
    } else {
      destinationController.text = item.label;
      _state =
          _state.copyWith(destination: item.label, arrivalCode: item.code);
    }
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context,
      {required bool isReturnDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final formatted =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      _state = isReturnDate
          ? _state.copyWith(returnDate: formatted)
          : _state.copyWith(selectedDate: formatted);
      notifyListeners();
    }
  }

  void selectDestinationFromModal(String label) {
    // destinationController.text = label;
    _updateState(state.copyWith(tempDestination: label));
  }

  void goToTourDetail(BuildContext context, TourItem tourItem) {
    final location = departureController.text.trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TourDetailScreen(
          name: tourItem.name,
          location: location.isNotEmpty
              ? location
              : _state.departure,
          date: _state.selectedDate,
        ),
      ),
    );
  }


  void updateTab(TravelTab tab) {
    _state = _state.copyWith(selectedTab: tab, isSearching: false);
    notifyListeners();
  }

  void resetSearch() {
    _state = _state.copyWith(isSearching: false, );
    notifyListeners();
  }

  void performTourSearch(String defaultDestination) {
    final raw = state.tempDestination.trim();
    final query = raw.toLowerCase();

    if (query.isEmpty || query == defaultDestination.toLowerCase()) {
      _updateState(
        state.copyWith(
          destination: '',
          tourList: List.from(state.initialList),
          isSearching: false,
        ),
      );
      return;
    }

    final results = state.initialList.where((tour) {
      final title = tour.name?.trim().toLowerCase() ?? '';
      final description = tour.description?.trim().toLowerCase() ?? '';
      final categoryMatches =
      tour.category.any((cat) => cat.name.trim().toLowerCase().contains(query));

      return title.contains(query) ||
          description.contains(query) ||
          categoryMatches;
    }).toList();

    _updateState(
      state.copyWith(
        destination: raw,        // ✅ xác nhận
        tourList: results,
        isSearching: true,
      ),
    );
  }

  void performFlightSearch(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (state.departureCode.isEmpty || state.arrivalCode.isEmpty) {
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
            destinationCode: state.arrivalCode,
            departureDate: state.selectedDate,
            returnDate: state.returnDate.toString(),
            adults: state.adultCount,
            children: state.childCount,
            infant: state.infantCount,
            isRoundTrip: state.isRoundTrip,
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

  void onDestinationSelected(
      BuildContext context,
      String destinationName,
      String defaultDeparture,
      ) {
    destinationController.text = destinationName;
    _updateState(state.copyWith(destination: destinationName));

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text('${l10n.home_destinationSnackbar} $destinationName'),
      ),
    );

    performTourSearch(defaultDeparture);
  }

  void updatePassengerData({
    required int adults,
    required int children,
    required int infants,
    required String selectedClass,
  }) {
    _state = state.copyWith(
      adultCount: adults,
      childCount: children,
      infantCount: infants,
      selectedClass: selectedClass,
    );
    notifyListeners();
  }

  void updateTripType(bool isRoundTrip) {
    _state = state.copyWith(
      isRoundTrip: isRoundTrip,
      returnDate: isRoundTrip ? _state.returnDate : null,
    );
    notifyListeners();
  }
  void resetToInitial() {
    _state = TravelBookingState.initial();

    departureController.clear();
    destinationController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    departureController.dispose();
    destinationController.dispose();
    super.dispose();
  }
}
