import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../data/models/tour_detail.dart';

class ScheduleSection extends StatefulWidget {
  final TourDetail detail;

  const ScheduleSection({super.key, required this.detail});

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.detail.schedules == null || widget.detail.schedules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      // Sử dụng lề chuẩn của hệ thống để thẳng hàng với các section khác
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề phần lịch trình
          Text(
            l10n.tour_detail_itinerary,
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D2939),
            ),
          ),

          // Thay h(2) bằng rh(16) để khoảng cách ổn định
          SizedBox(height: context.rh(16)),

          Column(
            children: List.generate(widget.detail.schedules.length, (index) {
              final schedule = widget.detail.schedules[index];
              final parts = schedule.name.split(':');
              final dayName = parts[0];
              final briefInfo = parts.length > 1 ? parts[1].trim() : '';
              final isExpanded = _expandedIndex == index;

              return _buildScheduleItem(
                context: context,
                index: index,
                dayName: dayName,
                briefInfo: briefInfo,
                description: schedule.description,
                isExpanded: isExpanded,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required BuildContext context,
    required int index,
    required String dayName,
    required String briefInfo,
    required String description,
    required bool isExpanded,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      // Thay h(1.5) bằng rh(12) cho khoảng cách giữa các thẻ
      margin: EdgeInsets.only(bottom: context.rh(12)),
      decoration: BoxDecoration(
        border: Border.all(
          color: isExpanded ? kPrimaryColor : kBorderColor.withOpacity(0.5),
          width: 1,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header của Item
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(context.radius),
            child: Padding(
              // Dùng rw(16) đồng bộ với padding hệ thống
              padding: EdgeInsets.all(context.rw(16)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: context.sp(15),
                            fontWeight: FontWeight.bold,
                            color: isExpanded
                                ? kPrimaryColor
                                : const Color(0xFF2D2D2D),
                          ),
                        ),
                        // Thay h(0.5) bằng rh(4)
                        SizedBox(height: context.rh(4)),
                        Text(
                          briefInfo,
                          style: TextStyle(
                            fontSize: context.sp(13),
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.rw(12)),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: context.icon(22),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nội dung HTML chi tiết
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const Divider(height: 1),
                Padding(
                  // Sử dụng context.padding để lề HTML khớp với lề Header
                  padding: EdgeInsets.all(context.padding),
                  child: HtmlWidget(
                    description,
                    textStyle: TextStyle(
                      fontSize: context.sp(13.5),
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Thêm khoảng đệm cuối khi mở rộng
                SizedBox(height: context.rh(8)),
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
