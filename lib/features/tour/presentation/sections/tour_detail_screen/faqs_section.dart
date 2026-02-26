import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/tour/app_layout_spacing.dart';
import '../../../data/models/tour_detail_faqs.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (widget.faqs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: AppLayoutSpacing.paddingFaqSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppLayoutSpacing.paddingFaqsTitleAndItem,
            child: Text(
              key: widget.key,
              l10n.consultation_faqs,
              style: AppStyles.faqTitle,
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: AppShape.decorationFaqItem,
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
              padding: AppLayoutSpacing.paddingFaqItem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      faq.question ?? "",
                      style: AppStyles.faqQuestion,
                    ),
                  ),
                  AppLayoutSpacing.iconAndValue,
                  // Icon xoay mượt mà giống NewsCard
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: AppIcons.expandedIcon,
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
                  faq.answer ?? l10n.faqs_answerLoading,
                  textStyle: AppStyles.faqAnswer,
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