import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/travel_booking_controller.dart';

class PaginationControl extends StatelessWidget {
  const PaginationControl({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng watch để UI tự động cập nhật khi trang thay đổi
    final controller = context.watch<TravelBookingController>();
    final state = controller.state;
    final int totalPages = controller.totalPages;

    // Nếu chỉ có 1 trang thì không hiện phân trang
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Wrap( // Sử dụng Wrap để tự động xuống dòng nếu quá nhiều số trang
        spacing: 8, // Khoảng cách ngang giữa các số
        runSpacing: 8, // Khoảng cách dọc
        alignment: WrapAlignment.center,
        children: List.generate(totalPages, (index) {
          final pageNumber = index + 1;
          final bool isSelected = state.tour.currentPage == pageNumber;

          return InkWell(
            onTap: () => {
              controller.loadTourPage(pageNumber),
              controller.scrollToTop(),
            },
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // Màu nền: Xanh đậm nếu được chọn, ngược lại để trong suốt
                color: isSelected ? const Color(0xFF006677) : Colors.transparent,
                borderRadius: BorderRadius.circular(12), // Bo góc giống ảnh
              ),
              child: Text(
                '$pageNumber',
                style: TextStyle(
                  // Màu chữ: Trắng nếu được chọn, ngược lại dùng màu xanh chủ đạo
                  color: isSelected ? Colors.white : const Color(0xFF006677),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
