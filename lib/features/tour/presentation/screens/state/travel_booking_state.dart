import 'package:final_project/features/tour/data/models/tour_detail.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../flight/data/models/list_airport.dart';
import '../../../data/models/tour_category.dart';
import '../../../data/models/tour_destination.dart';
import '../../../data/models/tour_item.dart';


class TravelBookingState {
  // ================== UI / FLOW STATE ==================
  final TravelTab selectedTab;
  final FlightTab selectedFlightTab;
  final bool isRoundTrip;
  final bool isSearching;
  final bool isInitialized;

  // ================== LOADING & ERROR ==================
  final bool isLoading;
  final String? errorMessage;

  final bool isTourListLoading;
  final String? tourListErrorMessage;

  // ================== FORM DATA ========================
  final String departure;
  final String departureCode;
  final String destination;
  final String tempDestination;
  final String arrivalCode;
  final String selectedDate;
  final String? returnDate; // TODO: DateTime?

  // ================== PASSENGER DATA ===================
  final int adultCount;
  final int childCount;
  final int infantCount;
  final String selectedClass;


  // ================== API DATA =========================
  final List<TourDestination> tourDestinations;
  final List<TourCategory> tourCategories;
  final List<ListAirport> listAirport;
  final List<TourItem> tourList;
  final List<TourItem> initialList;
  final TourDetail tourDetail;


  // ================== API DATA =========================
  final int currentPage;
  final int pageSize;


  const TravelBookingState({
    required this.selectedTab,
    required this.selectedFlightTab,
    required this.isRoundTrip,
    required this.isSearching,
    required this.isInitialized,
    required this.isLoading,
    required this.isTourListLoading,
    required this.departure,
    required this.departureCode,
    required this.destination,
    required this.tempDestination,
    required this.arrivalCode,
    required this.selectedDate,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.selectedClass,
    required this.tourDestinations,
    required this.tourCategories,
    required this.listAirport,
    required this.tourList,
    required this.initialList,
    required this.tourDetail,
    this.errorMessage,
    this.tourListErrorMessage,
    this.returnDate,
    required this.currentPage,
    required this.pageSize,
  });

  // ================== INITIAL STATE ====================
  factory TravelBookingState.initial() {
    final now = DateTime.now();
    return TravelBookingState(
      selectedTab: TravelTab.tour,
      selectedFlightTab: FlightTab.flight,
      isRoundTrip: true,
      isSearching: false,
      isInitialized: false,

      isLoading: true,
      isTourListLoading: true,

      departure: '',
      departureCode: '',
      destination: '',
      tempDestination: '',
      arrivalCode: '',
      selectedDate: '${now.day}-${now.month}-${now.year}',
      returnDate: null,

      adultCount: 1,
      childCount: 0,
      infantCount: 0,
      selectedClass: 'Economy',

      tourDestinations: const [],
      tourCategories: const [],
      listAirport: const [],
      tourList: const [],
      initialList: const [],
      tourDetail: const TourDetail(
        id: 0,
        sid: '',
        name: '',
        brief: '',
        image: '',
        images: [],
        reviews: [],
        schedules: [],
        extensions: [],
      ),

      currentPage: 1,
      pageSize: 5,
    );
  }

  // ================== COPY WITH ========================
  TravelBookingState copyWith({
    TravelTab? selectedTab,
    FlightTab? selectedFlightTab,
    bool? isRoundTrip,
    bool? isSearching,
    bool? isInitialized,
    bool? isLoading,
    String? errorMessage,
    bool? isTourListLoading,
    String? tourListErrorMessage,
    String? departure,
    String? departureCode,
    String? destination,
    String? tempDestination,
    String? arrivalCode,
    String? selectedDate,
    String? returnDate,
    int? adultCount,
    int? childCount,
    int? infantCount,
    String? selectedClass,
    List<TourDestination>? tourDestinations,
    List<TourCategory>? tourCategories,
    List<ListAirport>? listAirport,
    List<TourItem>? tourList,
    List<TourItem>? initialList,
    TourDetail? tourDetail,
    int? currentPage,
    int? pageSize
  }) {
    return TravelBookingState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFlightTab: selectedFlightTab ?? this.selectedFlightTab,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      isSearching: isSearching ?? this.isSearching,
      isInitialized: isInitialized ?? this.isInitialized,

      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isTourListLoading: isTourListLoading ?? this.isTourListLoading,
      tourListErrorMessage:
      tourListErrorMessage ?? this.tourListErrorMessage,

      departure: departure ?? this.departure,
      departureCode: departureCode ?? this.departureCode,
      destination: destination ?? this.destination,
      tempDestination: tempDestination ?? this.tempDestination,
      arrivalCode: arrivalCode ?? this.arrivalCode,
      selectedDate: selectedDate ?? this.selectedDate,
      returnDate: returnDate ?? this.returnDate,

      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      infantCount: infantCount ?? this.infantCount,
      selectedClass: selectedClass ?? this.selectedClass,

      tourDestinations: tourDestinations ?? this.tourDestinations,
      tourCategories: tourCategories ?? this.tourCategories,
      listAirport: listAirport ?? this.listAirport,
      tourList: tourList ?? this.tourList,
      initialList: initialList ?? this.initialList,
      tourDetail: tourDetail ?? this.tourDetail,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage
    );
  }
}
