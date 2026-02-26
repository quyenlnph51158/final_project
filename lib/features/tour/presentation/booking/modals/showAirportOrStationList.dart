import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_dividers.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/shared/widgets/drag_indicator.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';

import '../../controller/travel_booking_controller.dart';

class ShowAirportOrStationList extends StatelessWidget {
  final bool isDeparture;
  final IconData icon;
  final TravelBookingController controller; // Bổ sung controller

  const ShowAirportOrStationList({
    super.key,
    required this.isDeparture,
    required this.icon,
    required this.controller, // Yêu cầu truyền controller
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = controller.state; // Lấy state từ controller

    // Sử dụng biến enum từ State
    final bool isFlight = state.ui.selectedTab == TravelTab.flight;

    final String modalTitle = isFlight
        ? (isDeparture ? l10n.form_modalSelectAirportDeparture : l10n.form_modalSelectAirportArrival)
        : (isDeparture ? l10n.form_modalSelectStationDeparture : l10n.form_modalSelectStationArrival);

    // Dùng TextEditingController cục bộ cho ô tìm kiếm trong Modal
    final TextEditingController searchController = TextEditingController();

    return StatefulBuilder( // Cần StatefulBuilder để cập nhật danh sách khi gõ tìm kiếm
      builder: (context, modalSetState) {
        // Lấy danh sách đã lọc từ logic trong Controller
        final filteredList = controller.getFilteredLocations(searchController.text, isDeparture);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              // Thanh kéo (Handle) và Tiêu đề
              Padding(
                padding: AppLayoutSpacing.paddingHandleAndTitle,
                child: Column(
                  children: [
                    DragIndicator(),
                    AppLayoutSpacing.handleAndTitle,
                    Text(modalTitle,
                        style: AppStyles.titleShowList,)
                  ],
                ),
              ),
              // Ô nhập tìm kiếm
              Padding(
                padding: AppLayoutSpacing.paddingSearchBox,
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    modalSetState(() {}); // Chỉ làm mới Modal này
                  },
                  decoration: InputDecoration(
                    hintText: l10n.form_labelSearchHint,
                    prefixIcon: AppIcons.iconSearchBox,
                    border: AppShape.borderSearchBox,
                    filled: true,
                    fillColor: kFormFieldBackground,
                    contentPadding: AppLayoutSpacing.paddingContentSearchBox,
                  ),
                ),
              ),
              // Danh sách kết quả
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];

                    // Kiểm tra item có đang được chọn hay không
                    final isSelected = isDeparture
                        ? item.label == state.form.departure
                        : item.label == state.form.destination;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(item.label),
                          trailing: isSelected ? AppIcons.iconCheck : null,
                          onTap: () {
                            controller.selectLocation(item, isDeparture);
                            Navigator.pop(context);
                          },
                        ),
                        AppDividers.AirportAndStationName,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}