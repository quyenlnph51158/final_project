import 'package:final_project/core/data/model/home_tour_model.dart';
import 'package:final_project/features/tour/presentation/screens/tour_screen.dart';
import 'package:flutter/material.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/utils/format_date.dart';
import '../../../flight/data/models/list_airport.dart';
import '../../../flight/data/service/listairport_service.dart';
import '../../../flight/presentation/screens/flight_results_screen.dart';
import '../../data/models/location_item.dart';
import '../../data/models/tour_category.dart';
import '../../data/models/tour_destination.dart';
import '../../data/models/tour_item.dart';
import '../../data/service/api_service.dart';
import '../../data/service/category_service.dart';
import '../../data/service/tour_service.dart';
import '../../data/service/tourdetail_service.dart';
import '../screens/tour_detail_screen.dart';
import '../state/travel_booking_state.dart';
import '../state/travel_filter_state.dart';

class TravelBookingController extends ChangeNotifier {
  TravelBookingState _state = TravelBookingState.initial();
  TravelBookingState get state => _state;

  final ListAirportService _airportService = ListAirportService();
  final TourService _tourService = TourService();
  final CategoryService _categoryService = CategoryService();
  final ApiService _apiService = ApiService();
  final TourdetailService _tourDetailService = TourdetailService();

  final TextEditingController departureController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // ==============================
  // INTERNAL STATE UPDATE
  // ==============================

  void _updateState(TravelBookingState newState) {
    _state = newState;
    notifyListeners();
  }

  // ==============================
  // SCROLL
  // ==============================

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // ==============================
  // PAGINATION (TOUR)
  // ==============================

  List<TourItem> get currentTours {
    final filtered = state.tour.tourList.toList();

    final start =
        (state.tour.currentPage - 1) * state.tour.pageSize;
    final end =
    (start + state.tour.pageSize).clamp(0, filtered.length);

    if (start >= filtered.length) return [];

    return filtered.sublist(start, end);
  }
  List<LocationItem> getFilteredLocations(
      String query,
      bool isDeparture,
      ) {
    final otherValue =
    isDeparture ? _state.form.destination : _state.form.departure;


    if (_state.ui.selectedTab == TravelTab.flight) {
      return _state.flight.airports
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


    return _state.tour.destinations
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


  int get totalPages =>
      (state.tour.tourList.length /
          state.tour.pageSize)
          .ceil();

  void loadTourPage(int page) {
    _updateState(
      state.copyWith(
        tour: state.tour.copyWith(
          currentPage: page,
          isLoading: false,
        ),
      ),
    );
  }

  void nextPage() {
    if (state.tour.currentPage < totalPages) {
      loadTourPage(state.tour.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.tour.currentPage > 1) {
      loadTourPage(state.tour.currentPage - 1);
    }
  }

  // Khi chuyển Flight ↔ Tour
  // Reset dữ liệu tìm kiếm
  // Reset ngày
  // Set lại label input theo tab
  void changeTab(TravelTab tab, AppLocalizations l10n) {
    departureController.text =l10n.form_defaultDeparture;
    _state = _state.copyWith(
      ui: _state.ui.copyWith(
        selectedTab: tab,
        isSearching: false,
      ),
      form: _state.form.copyWith(
        departure: '',
        destination: '',
        tempDestination: '',
        selectedDate: FormatDate.formatDateDDMMYYYY(DateTime.now()).toString() ,
        returnDate: '',
        isRoundTrip: true,
      ),
      tour: _state.tour.copyWith(
        tourList: state.tour.initialList
      ),
    );
    notifyListeners();
  }


  // ==============================
  // INIT DATA
  // ==============================

  Future<void> initData(
      String defaultDeparture,
      String defaultDestination) async {
    if (state.ui.isInitialized) return;

    departureController.text = defaultDeparture;

    _updateState(
      state.copyWith(
        ui: state.ui.copyWith(isLoading: true),
        form: state.form.copyWith(
          departure: defaultDeparture,
          destination: defaultDestination,
        ),
      ),
    );

    try {
      final results = await Future.wait([
        _airportService.fetchListAirport(),
        _tourService.fetchTours(),
        _categoryService.fetchTourCategories(),
        _apiService.fetchTourDestinations(),
      ]);
      final rawTours = results[1] as List<TourItem>;

      // Sắp xếp ngay lập tức trước khi đưa vào State
      final defaultSortedTours = _sortTours(rawTours, SortOption.highestRating);
      _updateState(
        state.copyWith(
          ui: state.ui.copyWith(
            isLoading: false,
            isInitialized: true,
          ),
          flight: state.flight.copyWith(
            airports: results[0] as List<ListAirport>,
          ),
          filter: state.filter.copyWith(sortBy: SortOption.highestRating),
          tour: state.tour.copyWith(
            tourList: defaultSortedTours,
            initialList: defaultSortedTours,
            categories: results[2] as List<TourCategory>,
            destinations:
            results[3] as List<TourDestination>,
          ),
        ),
      );
    } catch (e) {
      _updateState(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
        ),
      );
    }
  }

  Future<void> fetchTourDetail(String name, String errorText) async {
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final detail =
      await _tourDetailService.fetchTourDetail(q: name);

      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(isLoading: false),
          tour: _state.tour.copyWith(
            tourDetail: detail,
          ),
        ),
      );
    } catch (e) {
      _updateState(
        _state.copyWith(
          ui: _state.ui.copyWith(
            isLoading: false,
            errorMessage: '$errorText $e',
          ),
        ),
      );
    }
  }


  // ==============================
  // FORM UPDATE
  // ==============================
  void updateTab(TravelTab tab) {
    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(
          selectedTab: tab,
          isSearching: false,
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
      state.copyWith(
        form: state.form.copyWith(
          adultCount: adults,
          childCount: children,
          infantCount: infants,
        ),
      ),
    );
  }

  Future<void> setDate(
      DateTime picked, {
        required bool isReturnDate,
      }) async {
    final formatted =
    FormatDate.formatDateDDMMYYYY(picked);

    _updateState(
      state.copyWith(
        form: isReturnDate
            ? state.form.copyWith(
            returnDate: formatted)
            : state.form.copyWith(
            selectedDate: formatted),
      ),
    );
  }

  // ==============================
  // TOUR SEARCH
  // ==============================

  void performTourSearch(
      String defaultDestination) {
    final raw = state.form.tempDestination.trim();
    final query = raw.toLowerCase();

    if (query.isEmpty ||
        query == defaultDestination.toLowerCase()) {
      _updateState(
        state.copyWith(
          form: state.form.copyWith(destination: ''),
          tour: state.tour.copyWith(
            tourList: List.from(state.tour.initialList),
          ),
        ),
      );
      return;
    }

    final results = state.tour.initialList.where((tour) {
      final title = tour.name?.toLowerCase() ?? '';
      final description = tour.description?.toLowerCase() ?? '';
      final categoryMatches =
      tour.category.any((cat) => cat.name.trim().toLowerCase().contains(query));

      return title.contains(query) ||
          description.contains(query) ||
          categoryMatches;
    }).toList();

    _updateState(
      state.copyWith(
        ui: state.ui.copyWith(isSearching: true),
        form: state.form.copyWith(destination: raw),
        tour: state.tour.copyWith(tourList: results),
      ),
    );
  }
  List<TourItem> _sortTours(List<TourItem> list, SortOption option) {
    List<TourItem> sortedList = List.from(list);
    switch (option) {
      case SortOption.priceHighToLow:
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.priceLowToHigh:
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.highestRating:
        sortedList.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case SortOption.durationShortToLong:
        sortedList.sort((a, b) => _extractDays(a.duration).compareTo(_extractDays(b.duration)));
        break;
      case SortOption.durationLongToShort:
        sortedList.sort((a, b) => _extractDays(b.duration).compareTo(_extractDays(a.duration)));
        break;
      default:
        break;
    }
    return sortedList;
  }
  void updateSortOption(SortOption option) {
    // Sắp xếp trên danh sách đang có (đã qua lọc hoặc search)
    final sortedTours = _sortTours(state.tour.tourList, option);

    _updateState(
      state.copyWith(
        filter: state.filter.copyWith(sortBy: option),
        tour: state.tour.copyWith(tourList: sortedTours),
      ),
    );
  }
  void toggleRatingFilter(int star) {
    // Tạo bản sao của danh sách rating đang chọn để tránh lỗi tham chiếu
    final List<int> currentFilters = List.from(state.filter.selectedRatings);

    if (currentFilters.contains(star)) {
      currentFilters.remove(star);
    } else {
      currentFilters.add(star);
    }

    _updateState(
      state.copyWith(
        filter: state.filter.copyWith(selectedRatings: currentFilters),
      ),
    );
  }
  // Logic chọn/bỏ chọn loại hình
  void toggleTourTypeFilter(String typeName) {
    final currentTypes = List<String>.from(state.filter.selectedTourTypes);

    if (currentTypes.contains(typeName)) {
      currentTypes.remove(typeName); // Bỏ chọn nếu đã tồn tại
    } else {
      currentTypes.add(typeName); // Thêm vào nếu chưa có
    }

    _state = state.copyWith(
      filter: state.filter.copyWith(selectedTourTypes: currentTypes),
    );
    notifyListeners();
  }

// Hàm này sẽ được gọi khi nhấn nút "Áp dụng" trên BottomSheet
  void applyFilters() {
    final filters = state.filter;

    // Luôn bắt đầu lọc từ danh sách gốc (initialList)
    List<TourItem> results = List.from(state.tour.initialList);

    // 1. Lọc theo đánh giá (Rating)
    if (filters.selectedRatings.isNotEmpty) {
      results = results.where((tour) {
        return filters.selectedRatings.contains(tour.reviewsCount);
      }).toList();
    }
    // Lọc theo Loại hình (Categories)
    if (state.filter.selectedTourTypes.isNotEmpty) {
      results = results.where((tour) {
        // Kiểm tra xem tour có chứa bất kỳ loại hình nào trong danh sách đang chọn không
        return tour.category.any((cat) =>
            state.filter.selectedTourTypes.contains(cat.name));
      }).toList();
    }
    // 2. Lọc theo từ khóa tìm kiếm hiện tại (nếu có)
    final query = state.form.tempDestination.toLowerCase().trim();
    if (query.isNotEmpty) {
      results = results.where((tour) {
        return (tour.name?.toLowerCase().contains(query) ?? false) ||
            (tour.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    _updateState(
      state.copyWith(
        ui: state.ui.copyWith(isSearching: true),
        tour: state.tour.copyWith(
          tourList: results,
          currentPage: 1, // Reset về trang 1 khi lọc
        ),
      ),
    );
  }
  int _extractDays(String? duration) {
    if (duration == null || duration.isEmpty) return 0;

    // Sử dụng RegExp để tìm con số đầu tiên trong chuỗi (số ngày)
    final RegExp regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(duration);

    if (match != null) {
      return int.parse(match.group(0)!);
    }
    return 0;
  }

  // ==============================
  // FLIGHT SEARCH
  // ==============================

  void performFlightSearch(
      AppLocalizations l10n) {
    final f = state.form;

    if (f.departureCode.isEmpty ||
        f.arrivalCode.isEmpty) {
      _updateState(
        state.copyWith(
          ui: state.ui.copyWith(
            errorMessage:
            l10n.error_flightSearchMissingInput,
          ),
        ),
      );
      return;
    }

    NavigationService.push(
      MaterialPageRoute(
        builder: (_) => FlightResultsScreen(
          departureCode: f.departureCode,
          destinationCode: f.arrivalCode,
          departureDate: f.selectedDate,
          returnDate: f.returnDate.toString(),
          adults: f.adultCount,
          children: f.childCount,
          infant: f.infantCount,
          isRoundTrip:
          state.form.isRoundTrip,
        ),
      ),
    );
  }

  // ==============================
  // TRIP TYPE
  // ==============================

  void updateTripType(bool isRoundTrip) {
    _updateState(
      state.copyWith(
        flight: state.flight.copyWith(
          outboundFlights: [],
          returnFlights: [],
          selectedOutboundFlight: null,
          selectedReturnFlight: null,
        ),
        form: state.form.copyWith(
          isRoundTrip: isRoundTrip,
          typeAirport:
          state.form.isRoundTrip ? 2 : 1,
        )
      ),
    );
  }
  void selectDestinationFromModal(String label) {
    // destinationController.text = label;
    _updateState(state.copyWith(
      form: state.form.copyWith(
        tempDestination: label)
      )
    );

  }
  void selectLocation(dynamic item, bool isDeparture) {
    if (isDeparture) {
      departureController.text = item.label;
      _state =
          _state.copyWith(
            form: _state.form.copyWith(
              departure: item.label, departureCode: item.code
            )
          );

    } else {
      // destinationController.text = item.label;
      _state =
          _state.copyWith(
            form: _state.form.copyWith(
              destination: item.label, arrivalCode: item.code
            ),
          );
    }
    notifyListeners();
  }
  void onDestinationSelected(
      String destinationName,
      String defaultDeparture,
      ) {
    _updateState(state.copyWith(
      form: state.form.copyWith(
        tempDestination: destinationName)
      )
    );
    performTourSearch(defaultDeparture);
  }
  // Điều hướng sang màn hình chi tiết tour
  void goToTourDetail( TourItem tourItem, AppLocalizations l10n) {
    final location;
    if(state.ui.selectedTab != TravelTab.tour){
      location = l10n.form_defaultDeparture;
    }
    else{
      location = departureController.text.trim();
    }
    NavigationService.push(
      MaterialPageRoute(
        builder: (_) => TourDetailScreen(
          name: tourItem.name,
          location: location,
          date: _state.form.selectedDate,
        ),
      ),
    );
  }
  void goToTourScreen(){
    final HomeTourData homeTourData = HomeTourData(
      departure: state.form.departure,
      destination: state.form.destination,
      departureDate: state.form.selectedDate,
    );
    NavigationService.pop();
    NavigationService.push(
      MaterialPageRoute(
        builder: (_) => TourScreen(homeData: homeTourData,),
      ),
    );
  }




  // ==============================
  // RESET
  // ==============================
  // Thoát chế độ search
  void resetSearch() {
    _state = _state.copyWith(
      ui: _state.ui.copyWith(
        isSearching: false,
      ),
    );
    notifyListeners();
  }

  void resetToInitial() {
    _state = TravelBookingState.initial();
    departureController.clear();
    notifyListeners();
  }

  // ==============================
  // DISPOSE
  // ==============================

  @override
  void dispose() {
    scrollController.dispose();
    departureController.dispose();
    super.dispose();
  }
}
