import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../controller/travel_booking_controller.dart';
import '../../state/travel_filter_state.dart';
import '../../widgets/tour_card_item.dart';
import '../../widgets/pagination_control.dart';
import '../../widgets/widget_tour_screen.dart';

class ListTourSection extends StatelessWidget {
  const ListTourSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      // Sử dụng lề chuẩn 12/16px đã được scale theo rw
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TIÊU ĐỀ DANH SÁCH
          Center(
            child: Text(
              controller.state.ui.isSearching
                  ? '${l10n.home_tourSectionTitleSearch} ${controller.state.form.destination}'
                  : l10n.tour_screenTourTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(22), // Dùng sp có clamp để tránh vỡ font
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D2939),
              ),
            ),
          ),

          SizedBox(height: context.rh(16)), // Khoảng cách dọc ổn định
          // 2. BỘ ĐÔI NÚT LỌC VÀ SẮP XẾP
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.tune_rounded,
                  label: l10n.filter,
                  onTap: () => _showFilterBottomSheet(context),
                ),
              ),
              SizedBox(width: context.rw(12)), // Khoảng cách ngang ổn định
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.sort_rounded,
                  label: l10n.sort,
                  onTap: () => _showSortBottomSheet(context),
                ),
              ),
            ],
          ),

          SizedBox(height: context.rh(20)),

          // 3. HIỂN THỊ KẾT QUẢ
          if (controller.state.tour.tourList.isEmpty)
            _buildEmptyState(context, l10n)
          else
            Column(
              children: controller.currentTours.map((tour) {
                return Padding(
                  padding: EdgeInsets.only(bottom: context.rh(16)),
                  child: TourCardItem(tour: tour),
                );
              }).toList(),
            ),

          const PaginationControl(),
          SizedBox(height: context.rh(20)),
        ],
      ),
    );
  }

  // --- WIDGET HELPER TỐI ƯU PIXEL-SCALE ---

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radius),
      child: Container(
        // Chiều cao nút tối thiểu ~44px để đạt chuẩn Touch Target
        padding: EdgeInsets.symmetric(vertical: context.rh(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.radius),
          border: Border.all(color: kBorderColor.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: context.icon(18), color: kPrimaryColor),
            SizedBox(width: context.rw(8)),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: context.sp(14),
                color: kTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rh(40)),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: context.icon(48),
              color: Colors.grey[300],
            ),
            SizedBox(height: context.rh(12)),
            Text(
              l10n.error_tourNotFound,
              style: TextStyle(fontSize: context.sp(14), color: Colors.grey),
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius * 1.5),
        ),
      ),
      builder: (context) {
        return Consumer<TravelBookingController>(
          builder: (context, controller, child) {
            final sortOptions = [
              {
                'label': l10n.sort_highestRating,
                'value': SortOption.highestRating,
              },
              {
                'label': l10n.sort_priceHighToLow,
                'value': SortOption.priceHighToLow,
              },
              {
                'label': l10n.sort_priveLowToHigh,
                'value': SortOption.priceLowToHigh,
              },
              {
                'label': l10n.sort_durationShortToLong,
                'value': SortOption.durationShortToLong,
              },
              {
                'label': l10n.sort_durationLongToShort,
                'value': SortOption.durationLongToShort,
              },
            ];

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.rh(12)),
                  Text(
                    l10n.sort,
                    style: TextStyle(
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(height: context.rh(24)),
                  ...sortOptions.map((option) {
                    final bool isSelected =
                        controller.state.filter.sortBy == option['value'];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.padding,
                      ),
                      title: Text(
                        option['label'] as String,
                        style: TextStyle(fontSize: context.sp(15)),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: kPrimaryColor,
                              size: context.icon(20),
                            )
                          : null,
                      onTap: () {
                        controller.updateSortOption(
                          option['value'] as SortOption,
                        );
                        Navigator.pop(context);
                      },
                    );
                  }),
                  SizedBox(height: context.rh(12)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius * 1.5),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.symmetric(vertical: context.rh(12)),
                  width: context.rw(40),
                  height: context.rh(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  l10n.filter,
                  style: TextStyle(
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.all(context.padding),
                    children: [
                      FilterSectionTitle(title: l10n.review),
                      const RatingFilterGroup(),
                      SizedBox(height: context.rh(24)),
                      FilterSectionTitle(title: l10n.sort),
                      const TourTypeFilterGroup(),
                    ],
                  ),
                ),
                // Nút Áp dụng (Sticky)
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(context.padding),
                    child: SizedBox(
                      width: double.infinity,
                      height: context.rh(48).clamp(45, 55),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.radius),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context
                              .read<TravelBookingController>()
                              .applyFilters();
                          Navigator.pop(context);
                        },
                        child: Text(
                          l10n.apply,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
