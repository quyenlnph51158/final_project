import 'package:final_project/core/design/tour/app_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/presentation/widgets/pagination_control.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../controller/travel_booking_controller.dart';
import '../state/travel_filter_state.dart';
import '../widgets/tour_card_item.dart';

class ListTourSection extends StatelessWidget{
  const ListTourSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller=context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: AppLayoutSpacing.paddingFeaturedTourSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              controller.state.ui.isSearching
                  ? '${l10n.home_tourSectionTitleSearch} ${controller.state.form.destination}'
                  : 'Tour du lịch',
              style: AppStyles.tourSectionTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    icon: Icons.tune, // Biểu tượng Lọc
                    label: "Lọc",
                    onTap: () => _showFilterBottomSheet(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterButton(
                    icon: Icons.sort, // Biểu tượng Sắp xếp
                    label: "Sắp xếp",
                    onTap: () => _showSortBottomSheet(context),
                  ),
                ),
              ],
            ),
          ),
          AppLayoutSpacing.labelandCard,
          if (controller.state.tour.tourList.isEmpty)
            Center(
              child: Padding(
                padding: AppLayoutSpacing.paddingTourCardError,
                child: Text(l10n.error_tourNotFound,
                    style: AppStyles.errorNotFound),
              ),
            )
          else
            ...controller.currentTours.map((tour) {
              return Padding(
                padding: AppLayoutSpacing.paddingTourCard,
                child: TourCardItem(tour: tour,),
              );
            }).toList(),
          AppSpacing.h4,
          PaginationControl(),
        ],
      ),
    );
  }
  // Widget tạo nút bo tròn như trong ảnh
  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100], // Màu nền nhạt
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<TravelBookingController>(
          builder: (context, controller, child) {
            // Định nghĩa danh sách option kèm theo Enum tương ứng
            final List<Map<String, dynamic>> sortOptions = [
              {'label': 'Đánh giá cao nhất', 'value': SortOption.highestRating},
              {'label': 'Giá cao đến thấp', 'value': SortOption.priceHighToLow},
              {'label': 'Giá thấp đến cao', 'value': SortOption.priceLowToHigh},
              {'label': 'Thời lượng tour (ngắn đến dài)', 'value': SortOption.durationShortToLong},
              {'label': 'Thời lượng tour (dài đến ngắn)', 'value': SortOption.durationLongToShort},
            ];

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sắp xếp", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  ...sortOptions.map((option) {
                    final bool isSelected = controller.state.filter.sortBy == option['value'];

                    return ListTile(
                      title: Text(option['label']),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.teal)
                          : null,
                      onTap: () {
                        // Truyền đúng kiểu SortOption (Enum) vào controller
                        controller.updateSortOption(option['value']);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _showFilterBottomSheet(BuildContext context) {
    // final categories= context.watch<TravelBookingController>().state.tour.categories;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Để sheet cao hơn
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Lọc", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildSectionTitle("Đánh giá"),
                      _buildRatingFilter(context),

                      // _buildSectionTitle("Khu vực"),
                      // const ExpansionTile(title: Text("Miền Bắc")),
                      // const ExpansionTile(title: Text("Miền Trung")),
                      // const ExpansionTile(title: Text("Miền Nam")),
                      _buildSectionTitle("Loại hình"),
                      // Sử dụng Consumer để tối ưu việc rebuild chỉ trong vùng này
                      Consumer<TravelBookingController>(
                        builder: (context, controller, child) {
                          // Lấy danh sách ID hoặc tên đang được chọn từ state
                          final selectedTypes = controller.state.filter.selectedTourTypes;

                          return Column(
                            children: controller.state.tour.categories.map((type) {
                              // Kiểm tra xem loại hình này có nằm trong danh sách đã chọn không
                              final isSelected = selectedTypes.contains(type.name);

                              return CheckboxListTile(
                                title: Text(type.name),
                                value: isSelected, // Giá trị động theo State
                                activeColor: Colors.teal,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (bool? val) {
                                  // Gọi hàm toggle đã viết ở Controller
                                  controller.toggleTourTypeFilter(type.name);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Nút Áp dụng (Floating at bottom)
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                    onPressed: () {
                      context.read<TravelBookingController>().applyFilters(); // Thực thi lọc dữ liệu
                      Navigator.pop(context);    // Đóng BottomSheet
                    },
                    child: const Text("Áp dụng", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
  Widget _buildRatingFilter(BuildContext context) {
    // Danh sách các cấp độ đánh giá tương ứng với số sao và nhãn
    final List<Map<String, dynamic>> ratings = [
      {'stars': 5, 'label': 'Tuyệt vời'},
      {'stars': 4, 'label': 'Tốt'},
      {'stars': 3, 'label': 'Ổn'},
      {'stars': 2, 'label': 'Không ổn'},
      {'stars': 1, 'label': 'Tệ'},
    ];

    return Consumer<TravelBookingController>(
      builder: (context, controller, child) {
        return Column(
          children: ratings.map((rating) {
            final int starCount = rating['stars'];
            final String label = rating['label'];
            // Kiểm tra xem hạng mục này có đang được chọn hay không
            final bool isSelected = controller.state.filter.selectedRatings.contains(starCount);

            return InkWell(
              onTap: () => controller.toggleRatingFilter(starCount),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // 1. Checkbox thủ công để giống ảnh mẫu
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isSelected,
                        activeColor: Colors.teal,
                        onChanged: (bool? value) {
                          controller.toggleRatingFilter(starCount);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 2. Hệ thống sao (5 ngôi sao, tô màu dựa trên số lượng)
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 20,
                          color: index < starCount ? Colors.orange[300] : Colors.grey[300],
                        );
                      }),
                    ),
                    const SizedBox(width: 12),

                    // 3. Nhãn văn bản
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

}