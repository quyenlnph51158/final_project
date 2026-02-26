import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/presentation/widgets/widget_tour_screen.dart';
import 'package:final_project/features/tour/presentation/widgets/pagination_control.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/tour/app_layout_spacing.dart';
import '../../controller/travel_booking_controller.dart';
import '../../state/travel_filter_state.dart';
import '../../widgets/tour_card_item.dart';

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
                  : l10n.tour_screenTourTitle,
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
                    label: l10n.filter,
                    onTap: () => _showFilterBottomSheet(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterButton(
                    icon: Icons.sort, // Biểu tượng Sắp xếp
                    label: l10n.sort,
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
    final l10n = AppLocalizations.of(context)!;
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
              {'label': l10n.sort_highestRating, 'value': SortOption.highestRating},
              {'label': l10n.sort_priceHighToLow, 'value': SortOption.priceHighToLow},
              {'label': l10n.sort_priveLowToHigh, 'value': SortOption.priceLowToHigh},
              {'label': l10n.sort_durationShortToLong, 'value': SortOption.durationShortToLong},
              {'label': l10n.sort_durationLongToShort, 'value': SortOption.durationLongToShort},
            ];

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.sort, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    final l10n = AppLocalizations.of(context)!;
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
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(l10n.filter, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      FilterSectionTitle(title: l10n.review),
                      RatingFilterGroup(),

                      // _buildSectionTitle("Khu vực"),
                      // const ExpansionTile(title: Text("Miền Bắc")),
                      // const ExpansionTile(title: Text("Miền Trung")),
                      // const ExpansionTile(title: Text("Miền Nam")),

                      FilterSectionTitle(title: l10n.sort),
                      // Sử dụng Consumer để tối ưu việc rebuild chỉ trong vùng này
                      TourTypeFilterGroup(),
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
                    child: Text(l10n.apply, style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}