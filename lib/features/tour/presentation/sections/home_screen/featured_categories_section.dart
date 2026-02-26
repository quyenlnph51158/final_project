import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../controller/travel_booking_controller.dart';
import '../../widgets/destination_card.dart';

class FeaturedDestinationSection extends StatefulWidget {
  const FeaturedDestinationSection({super.key});

  @override
  State<FeaturedDestinationSection> createState() => _FeaturedDestinationSectionState();
}

class _FeaturedDestinationSectionState extends State<FeaturedDestinationSection> {
  // 1. Sử dụng PageController thay vì ScrollController
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    final categories = controller.state.tour.categories;

    // 2. Tính toán số lượng trang (mỗi trang 2 item)
    final int itemsPerPage = 2;
    final int pageCount = (categories.length / itemsPerPage).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppLayoutSpacing.paddingDestinationSection,
          child: Center(
            child: Text(
              l10n.home_destinationsTitle,
              style: AppStyles.titleCategory,
            ),
          ),
        ),
        SizedBox(
          height: AppSizes.destinationListHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: pageCount,
            itemBuilder: (context, pageIndex) {
              // 3. Lấy ra 2 item cho mỗi trang
              final int firstIndex = pageIndex * itemsPerPage;
              final int secondIndex = firstIndex + 1;

              return Row(
                children: [
                  // Item thứ nhất của trang
                  if (firstIndex < categories.length)
                    Expanded(
                      child: DestinationCard(category: categories[firstIndex]),
                    ),
                  // Item thứ hai của trang
                  if (secondIndex < categories.length)
                    Expanded(
                      child: DestinationCard(category: categories[secondIndex]),
                    )
                  else
                    const Expanded(child: SizedBox()), // Giữ layout cân đối nếu trang cuối chỉ có 1 item
                ],
              );
            },
          ),
        ),

        // 4. Indicator có khả năng tương tác (Click để chuyển trang)
        AppLayoutSpacing.itemAndPagination,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
                (index) => GestureDetector(
              onTap: () {
                // Chuyển trang khi ấn vào dấu chấm
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: _buildDot(index == _currentPage),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 20 : 8, // Làm dấu chấm dài ra một chút khi active cho hiện đại
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF006677) : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4), // Bo góc để hợp với chiều rộng thay đổi
      ),
    );
  }
}