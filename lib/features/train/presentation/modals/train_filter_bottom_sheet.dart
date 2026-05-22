import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/train_controller.dart';

class TrainFilterBottomSheet extends StatefulWidget {
  const TrainFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const TrainFilterBottomSheet(),
    );
  }

  @override
  State<TrainFilterBottomSheet> createState() => _TrainFilterBottomSheetState();
}

class _TrainFilterBottomSheetState extends State<TrainFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrainController>();
    final l10n = AppLocalizations.of(context)!;

    Map<String, String> departureTimes = {
      l10n.time_early: 'Sớm',
      l10n.time_morning: 'Sáng',
      l10n.time_afternoon: 'Trưa',
      l10n.time_evening: 'Tối',
    };

    Map<String, String> arrivalTimes = {
      l10n.time_early: 'Sớm',
      l10n.time_morning: 'Sáng',
      l10n.time_afternoon: 'Trưa',
      l10n.time_evening: 'Tối',
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius * 1.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.padding,
            context.rh(8), // Thay h(1) bằng rh(8)
            context.padding,
            context.padding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HANDLE BAR ---
              Center(
                child: Container(
                  width: context.rw(40),
                  // Thay w(10) bằng rw(40)
                  height: context.rh(4),
                  // Thay 4 bằng rh(4)
                  margin: EdgeInsets.only(bottom: context.rh(16)),
                  // Thay h(2) bằng rh(16)
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(context.radius),
                  ),
                ),
              ),

              // --- HEADER ---
              Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    size: context.icon(24),
                    color: const Color(0xFF263238),
                  ),
                  SizedBox(width: context.rw(12)), // Thay w(3) bằng rw(12)
                  Text(
                    l10n.filter,
                    style: TextStyle(
                      fontSize: context.sp(18), // Giảm nhẹ xuống 18 cho vừa vặn
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF263238),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: context.icon(24)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Divider(height: context.rh(32)),
              // Dùng rh cho khoảng cách divider

              // --- BODY: Giờ khởi hành ---
              _buildSectionHeader(context, l10n.departure_time),
              ...departureTimes.entries
                  .map(
                    (e) => _buildFilterItem(
                      title: e.key,
                      value: e.value,
                      isDeparture: true,
                    ),
                  )
                  .toList(),

              SizedBox(height: context.rh(16)),
              // Thay h(2) bằng rh(16)

              // --- BODY: Giờ đến ---
              _buildSectionHeader(context, l10n.arrivalTime),
              ...arrivalTimes.entries
                  .map(
                    (e) => _buildFilterItem(
                      title: e.key,
                      value: e.value,
                      isDeparture: false,
                    ),
                  )
                  .toList(),

              SizedBox(height: context.rh(32)),
              // Thay h(4) bằng rh(32)

              // --- FOOTER: Nút Áp dụng ---
              SizedBox(
                width: double.infinity,
                height: context.rh(48).clamp(45.0, 55.0),
                // Cố định chiều cao theo rh
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.applyTrainFilter();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius),
                    ),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(12)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: context.sp(16),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF263238),
        ),
      ),
    );
  }

  Widget _buildFilterItem({
    required String title,
    required String value,
    required bool isDeparture,
  }) {
    final controller = context.watch<TrainController>();
    final filter = controller.state.filter;
    bool isSelected = isDeparture
        ? filter.filterTimeStart.contains(value)
        : filter.filterTimeEnd.contains(value);

    return InkWell(
      onTap: () {
        context.read<TrainController>().toggleTrainFilter(
          filterStart: isDeparture ? value : null,
          filterEnd: isDeparture ? null : value,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rh(8)),
        // Thay h(1) bằng rh(8)
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.icon(22),
              height: context.icon(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.radius * 0.4),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? kPrimaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: context.icon(16),
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: context.rw(12)), // Thay w(3) bằng rw(12)
            Text(
              title,
              style: TextStyle(
                fontSize: context.sp(15),
                color: isSelected ? Colors.black : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
