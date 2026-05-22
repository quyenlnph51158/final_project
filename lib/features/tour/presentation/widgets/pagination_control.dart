import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/travel_booking_controller.dart';

class PaginationControl extends StatelessWidget {
  const PaginationControl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final state = controller.state;
    final int totalPages = state.tour.totalPages;

    if (totalPages <= 1) return const SizedBox.shrink();

    // Thay vì dùng % (w(11)), ta dùng rw(40) để nút có kích thước ~40px
    // tỉ lệ thuận với chiều rộng màn hình thiết kế.
    final double buttonSize = context.rw(40).clamp(32.0, 48.0);

    return Padding(
      // Thay h(2.5) bằng rh(24) để khoảng cách dọc ổn định theo pixel scale
      padding: EdgeInsets.symmetric(vertical: context.rh(24)),
      child: Wrap(
        // Thay w(2) bằng rw(8) để khoảng cách giữa các nút không bị dãn quá rộng trên máy to
        spacing: context.rw(8),
        runSpacing: context.rw(8),
        alignment: WrapAlignment.center,
        children: List.generate(totalPages, (index) {
          final pageNumber = index + 1;
          final bool isSelected = state.tour.currentPage == pageNumber;

          return InkWell(
            onTap: () async {
              await controller.loadTourPage(pageNumber);
              controller.scrollToTop();
            },
            // Sử dụng radius chuẩn (10px cho máy nhỏ, 14px cho máy thường)
            borderRadius: BorderRadius.circular(context.radius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: buttonSize,
              height: buttonSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF006677)
                    : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(
                        color: const Color(0xFF006677).withOpacity(0.3),
                      ),
                borderRadius: BorderRadius.circular(
                  context.radius * 0.8,
                ), // Bo góc nhẹ hơn card một chút
              ),
              child: Text(
                '$pageNumber',
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF006677),
                  fontWeight: FontWeight.bold,
                  // Dùng sp() để font chữ không bị tràn nút khi người dùng chỉnh font hệ thống lớn
                  fontSize: context.sp(15),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
