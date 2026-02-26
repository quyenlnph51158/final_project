import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../../data/models/tour_detail_faqs.dart';

class FaqSection extends StatefulWidget {
  final List<TourDetailFaqs> faqs;

  const FaqSection({super.key, required this.faqs});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  // Lưu trữ index đang mở. Nếu là -1 nghĩa là đang đóng hết.
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.faqs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: AppLayoutSpacing.paddingFaqSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Câu hỏi thường gặp",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Danh sách các câu hỏi
          ...List.generate(widget.faqs.length, (index) {
            final faq = widget.faqs[index];
            final isExpanded = _expandedIndex == index;

            return _buildFaqItem(faq, isExpanded, index);
          }),
        ],
      ),
    );
  }

  Widget _buildFaqItem(TourDetailFaqs faq, bool isExpanded, int index) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Phần Header của FAQ (Câu hỏi)
          InkWell(
            onTap: () {
              setState(() {
                // Nếu bấm vào câu đang mở thì đóng lại, ngược lại thì mở câu mới
                _expandedIndex = isExpanded ? -1 : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      faq.question ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Icon xoay mượt mà giống NewsCard
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Phần Content của FAQ (Câu trả lời)
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0), // Trạng thái đóng
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: HtmlWidget(
                  faq.answer ?? "Nội dung đang được cập nhật...",
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOut, // Hiệu ứng cuộn lên xuống mượt mà
          ),
        ],
      ),
    );
  }
}