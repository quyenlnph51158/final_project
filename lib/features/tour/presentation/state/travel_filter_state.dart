enum SortOption {
  highestRating,
  priceHighToLow,
  priceLowToHigh,
  durationShortToLong,
  durationLongToShort,
}
// Định nghĩa các tiêu chí lọc
class TravelFilterState {
  final List<int> selectedRatings; // Lưu danh sách sao (ví dụ: [5, 4])
  final List<String> selectedAreas;  // Lưu khu vực (Miền Bắc, Trung, Nam)
  final List<String> selectedTourTypes; // Lưu loại hình (Tour biển, Trekking...)
  final SortOption sortBy; // Lưu tiêu chí sắp xếp hiện tại
  const TravelFilterState({
    required this.selectedRatings,
    required this.selectedAreas,
    required this.selectedTourTypes,
    required this.sortBy
  });
  factory TravelFilterState.initial() {
    return const TravelFilterState(
      selectedRatings: [],
      selectedAreas: [],
      selectedTourTypes: [],
      sortBy: SortOption.highestRating, // Giá trị mặc định
    );
  }

  // Hàm copyWith để cập nhật state (Immutability)
  TravelFilterState copyWith({
    List<int>? selectedRatings,
    List<String>? selectedAreas,
    List<String>? selectedTourTypes,
    SortOption? sortBy,
  }) {
    return TravelFilterState(
      selectedRatings: selectedRatings ?? this.selectedRatings,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      selectedTourTypes: selectedTourTypes ?? this.selectedTourTypes,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}