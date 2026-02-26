import 'package:final_project/core/data/model/home_tour_model.dart';
import 'package:final_project/features/tour/presentation/screens/tour_screen.dart';
import 'package:final_project/features/tour/presentation/state/booking_form_state.dart';
import 'package:flutter/material.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/utils/format_date.dart';
import '../../../flight/data/models/list_airport.dart';
import '../../../flight/data/service/listairport_service.dart';
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

  // =========================================================
  // 1. STATE MANAGEMENT
  // =========================================================

  /// State chính của toàn bộ màn hình Travel Booking
  TravelBookingState _state = TravelBookingState.initial();
  TravelBookingState get state => _state;

  /// Hàm nội bộ dùng để update state và notify UI
  void _updateState(TravelBookingState newState) {
    _state = newState;
    notifyListeners();
  }

  // =========================================================
  // 2. SERVICES (CALL API / DATA)
  // =========================================================

  final ListAirportService _airportService = ListAirportService();
  final TourService _tourService = TourService();
  final CategoryService _categoryService = CategoryService();
  final ApiService _apiService = ApiService();
  final TourdetailService _tourDetailService = TourdetailService();

  // =========================================================
  // 3. CONTROLLERS
  // =========================================================

  /// Controller cho input điểm đi
  final TextEditingController departureController = TextEditingController();

  /// Scroll controller dùng để scroll lên top khi đổi page
  final ScrollController scrollController = ScrollController();

  // =========================================================
  // 4. INIT DATA
  // =========================================================

  /// Hàm khởi tạo dữ liệu ban đầu cho màn hình
  /// - Load airport
  /// - Load category
  /// - Load destination
  /// - Load tour trang đầu
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
        _categoryService.fetchTourCategories(),
        _apiService.fetchTourDestinations(),
      ]);

      final tourData = await _tourService.fetchTours(
        page: 1,
        sortBy: "priceSmallest",
      );

      final rawTours = tourData['tours'] as List<TourItem>;
      final pagination = tourData['pagination'];

      _updateState(
        state.copyWith(
          ui: state.ui.copyWith(
            isLoading: false,
            isInitialized: true,
          ),
          flight: state.flight.copyWith(
            airports: results[0] as List<ListAirport>,
          ),
          filter: state.filter.copyWith(
            sortBy: SortOption.highestRating,
          ),
          tour: state.tour.copyWith(
            tourList: rawTours,
            initialList: rawTours,
            totalPages: pagination['last_page'] ?? 1,
            currentPage: 1,
            categories: results[1] as List<TourCategory>,
            destinations: results[2] as List<TourDestination>,
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
  // =========================================================
// TOUR DETAIL
// =========================================================

  /// Load chi tiết tour theo tên
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

  // =========================================================
  // 5. SCROLL
  // =========================================================

  /// Scroll danh sách về đầu trang
  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // =========================================================
  // 6. TAB & FORM HANDLING
  // =========================================================

  /// Đổi tab Flight ↔ Tour
  /// Reset form và dữ liệu tìm kiếm
  void changeTab(TravelTab tab, AppLocalizations l10n) {
    departureController.text = l10n.form_defaultDeparture;

    _updateState(
      _state.copyWith(
        ui: _state.ui.copyWith(
          selectedTab: tab,
          isSearching: false,
        ),
        form: _state.form.copyWith(
          departure: '',
          destination: '',
          tempDestination: '',
          selectedDate:
          FormatDate.formatDateDDMMYYYY(DateTime.now()).toString(),
          returnDate: '',
          isRoundTrip: true,
        ),
        tour: _state.tour.copyWith(
          tourList: state.tour.initialList,
        ),
      ),
    );
  }

  /// Update tab nhưng không reset form
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

  /// Update form từ dữ liệu Home truyền sang
  void updateTourForm(HomeTourData? homeData) {
    _updateState(
      _state.copyWith(
        form: _state.form.copyWith(
          tempDestination: homeData?.destination,
          selectedDate: homeData?.departureDate,
          departure: homeData?.departure,
        ),
      ),
    );
  }

  /// Cập nhật ngày đi hoặc ngày về
  Future<void> setDate(
      DateTime picked, {
        required bool isReturnDate,
      }) async {
    final formatted = FormatDate.formatDateDDMMYYYY(picked);

    _updateState(
      state.copyWith(
        form: isReturnDate
            ? state.form.copyWith(returnDate: formatted)
            : state.form.copyWith(selectedDate: formatted),
      ),
    );
  }

  /// Chọn destination từ modal
  void selectDestinationFromModal(String label) {
    _updateState(
      state.copyWith(
        form: state.form.copyWith(tempDestination: label),
      ),
    );
  }

  // =========================================================
  // 7. PAGINATION (TOUR)
  // =========================================================

  /// Load tour theo trang (server-side pagination)
  Future<void> loadTourPage(int page) async {
    _updateState(state.copyWith(
      tour: state.tour.copyWith(isLoading: true),
    ));

    try {
      final filters = state.filter;

      String sortParam = "ratingHighToLow";
      if (filters.sortBy == SortOption.priceHighToLow) {
        sortParam = "priceBiggest";
      }
      if(filters.sortBy == SortOption.priceLowToHigh){
        sortParam = "priceSmallest";
      }
      if(filters.sortBy == SortOption.durationLongToShort){
        sortParam = "startTimeDesc";
      }
      if(filters.sortBy == SortOption.durationShortToLong){
        sortParam = "startTimeAsc";
      }
      if(filters.sortBy == SortOption.highestRating){
        sortParam = "ratingHighToLow";
      }

      final result = await _tourService.fetchTours(
        page: page,
        travelTo: state.form.tempDestination,
        typeTours: filters.selectedTourTypes,
        propertyRatings: filters.selectedRatings,
        sortBy: sortParam,
      );

      final List<TourItem> tours = result['tours'];
      final pagination = result['pagination'];

      _updateState(
        state.copyWith(
          tour: state.tour.copyWith(
            tourList: tours,
            initialList:
            page == 1 ? tours : state.tour.initialList,
            currentPage: page,
            totalPages: pagination['last_page'] ?? 1,
            isLoading: false,
          ),
        ),
      );
    } catch (e) {
      _updateState(state.copyWith(
        tour: state.tour.copyWith(isLoading: false),
      ));
    }
  }

  /// Lấy danh sách tour hiện tại
  List<TourItem> get currentTours => state.tour.tourList;

  // =========================================================
  // 8. FILTER & SORT
  // =========================================================

  /// Cập nhật sort option và reload page 1
  void updateSortOption(SortOption option) {
    _updateState(
      state.copyWith(
        filter: state.filter.copyWith(sortBy: option),
      ),
    );

    loadTourPage(1);
  }

  /// Toggle filter theo rating
  void toggleRatingFilter(int star) {
    final currentFilters =
    List<int>.from(state.filter.selectedRatings);

    if (currentFilters.contains(star)) {
      currentFilters.remove(star);
    } else {
      currentFilters.add(star);
    }

    _updateState(
      state.copyWith(
        filter: state.filter.copyWith(
          selectedRatings: currentFilters,
        ),
      ),
    );
  }

  /// Toggle filter theo loại tour
  void toggleTourTypeFilter(int typeId) {
    final currentTypes =
    List<int>.from(state.filter.selectedTourTypes);

    if (currentTypes.contains(typeId)) {
      currentTypes.remove(typeId);
    } else {
      currentTypes.add(typeId);
    }

    _updateState(
      state.copyWith(
        filter: state.filter.copyWith(
          selectedTourTypes: currentTypes,
        ),
      ),
    );
  }

  /// Nhấn nút Apply Filter
  void applyFilters() {
    _updateState(
      state.copyWith(
        ui: state.ui.copyWith(isSearching: true),
      ),
    );
    loadTourPage(1);
  }

  // =========================================================
  // 9. SEARCH
  // =========================================================

  /// Thực hiện tìm kiếm tour
  void performTourSearch(String defaultDestination) {
    final raw = state.form.tempDestination.trim();

    if (raw.isEmpty ||
        raw.toLowerCase() ==
            defaultDestination.toLowerCase()) {
      _updateState(
        state.copyWith(
          form: state.form.copyWith(destination: ''),
        ),
      );
      loadTourPage(1);
      return;
    }

    _updateState(
      state.copyWith(
        ui: state.ui.copyWith(isSearching: true),
        form: state.form.copyWith(destination: raw),
      ),
    );

    loadTourPage(1);
  }

  // =========================================================
  // 10. NAVIGATION
  // =========================================================

  /// Điều hướng sang màn hình chi tiết tour
  void goToTourDetail(
      TourItem tourItem,
      AppLocalizations l10n) {

    final location =
    state.ui.selectedTab != TravelTab.tour
        ? l10n.form_defaultDeparture
        : departureController.text.trim();

    NavigationService.push(
      MaterialPageRoute(
        builder: (_) => TourDetailScreen(
          name: tourItem.name,
          location: location,
          date: state.form.selectedDate,
        ),
      ),
    );
  }

  /// Điều hướng sang màn hình TourScreen
  void goToTourScreen() {
    final homeTourData = HomeTourData(
      departure: state.form.departure,
      destination: state.form.tempDestination,
      departureDate: state.form.selectedDate,
    );

    NavigationService.pop();
    NavigationService.push(
      MaterialPageRoute(
        builder: (_) =>
            TourScreen(homeData: homeTourData),
      ),
    );
  }

  // =========================================================
  // 11. RESET
  // =========================================================

  /// Thoát chế độ search
  void resetSearch() {
    _updateState(
      state.copyWith(
        ui: state.ui.copyWith(isSearching: false),
      ),
    );
  }

  /// Reset toàn bộ về trạng thái ban đầu
  void resetToHome() {
    _state = TravelBookingState.initial();
    departureController.clear();
    notifyListeners();
  }

  /// Reset form nhưng giữ lại danh sách tour ban đầu
  void resetToInitial() {
    _updateState(
      state.copyWith(
        form: BookingFormState.initial(),
        tour: state.tour.copyWith(
          tourList:
          List.from(state.tour.initialList),
        ),
      ),
    );
  }

  // =========================================================
  // 12. DISPOSE
  // =========================================================

  @override
  void dispose() {
    scrollController.dispose();
    departureController.dispose();
    super.dispose();
  }
}
