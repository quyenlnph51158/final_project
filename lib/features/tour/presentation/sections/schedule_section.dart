import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../../data/models/tour_detail.dart';

class ScheduleSection extends StatefulWidget {
  final TourDetail detail;

  const ScheduleSection({
    super.key,
    required this.detail,
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}
class _ScheduleSectionState extends State<ScheduleSection> {
  int? _expandedIndex; // chỉ 1 ngày được mở

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.detail.schedules == null ||
        widget.detail.schedules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: AppLayoutSpacing.scheduleTourDetailSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tour_detail_itinerary,
            style: AppStyles.titleScheduleSection,
          ),
          AppLayoutSpacing.labelandcontent,

          Column(
            children: List.generate(
              widget.detail.schedules.length,
                  (index) {
                final schedule = widget.detail.schedules[index];
                final parts = schedule.name.split(':');
                final dayName = parts[0];
                final briefInfo = parts.length > 1 ? parts[1].trim() : '';

                final isExpanded = _expandedIndex == index;

                return _buildScheduleItem(
                  index: index,
                  dayName: dayName,
                  briefInfo: briefInfo,
                  description: schedule.description,
                  isExpanded: isExpanded,
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required int index,
    required String dayName,
    required String briefInfo,
    required String description,
    required bool isExpanded,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: kBorderColor,
          width: 1,
        ),
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex =
                isExpanded ? null : index; // auto collapse
              });
            },
            child: Padding(
              padding: AppLayoutSpacing.paddingContentScheduleItem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLayoutSpacing.iconAndContent,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: AppStyles.dayNameScheduleSection,
                        ),
                        AppLayoutSpacing.dayNameAndBriefInfo,
                        Text(
                          briefInfo,
                          style: AppStyles.briefInfoScheduleSection,
                        ),
                      ],
                    ),
                  ),

                  /// ICON XOAY MƯỢT
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: AppIcons.expandedDescriptionSchedule,
                  ),
                ],
              ),
            ),
          ),

          /// NỘI DUNG MỞ RỘNG
          AnimatedCrossFade(
            // Trạng thái khi đóng: Một khoảng trắng không có chiều cao
            firstChild: const SizedBox(width: double.infinity, height: 0),

            // Trạng thái khi mở: Nội dung HTML của bạn
            secondChild: Padding(
              padding: AppLayoutSpacing.paddingExpadedDescriptionSchedule,
              child: HtmlWidget(
                description,
                textStyle: AppStyles.descriptionScheduleSection,
              ),
            ),

            // Điều kiện để chuyển đổi giữa 2 trạng thái
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,

            duration: const Duration(milliseconds: 400),

            // Curve cho hiệu ứng thay đổi kích thước (cuộn lên/xuống)
            sizeCurve: Curves.easeOutCubic,

            // Curve cho hiệu ứng mờ dần (fade)
            firstCurve: Curves.linear,
            secondCurve: Curves.linear,
          ),

        ],
      ),
    );
  }
}
