import '../../data/models/tour_category.dart';
import '../../data/models/tour_destination.dart';
import '../../data/models/tour_detail.dart';
import '../../data/models/tour_item.dart';

class TourState {
  final List<TourItem> tourList;
  final List<TourItem> initialList;
  final List<TourCategory> categories;
  final List<TourDestination> destinations;
  final TourDetail tourDetail;

  final int currentPage;
  final int pageSize;
  final bool isLoading;

  const TourState({
    required this.tourList,
    required this.initialList,
    required this.categories,
    required this.destinations,
    required this.tourDetail,
    required this.currentPage,
    required this.pageSize,
    required this.isLoading,
  });

  factory TourState.initial() {
    return const TourState(
      tourList: [],
      initialList: [],
      categories: [],
      destinations: [],
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
      faqs: [],
      ),
      currentPage: 1,
      pageSize: 5,
      isLoading: true,

    );
  }

  TourState copyWith({
    List<TourItem>? tourList,
    List<TourItem>? initialList,
    List<TourCategory>? categories,
    List<TourDestination>? destinations,
    TourDetail? tourDetail,
    int? currentPage,
    int? pageSize,
    bool? isLoading,
  }) {
    return TourState(
      tourList: tourList ?? this.tourList,
      initialList: initialList ?? this.initialList,
      categories: categories ?? this.categories,
      destinations: destinations ?? this.destinations,
      tourDetail: tourDetail ?? this.tourDetail,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
