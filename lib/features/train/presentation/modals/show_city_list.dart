import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';

class ShowCityList extends StatelessWidget {
  final bool isDeparture;
  final IconData icon;
  final TrainController controller;

  const ShowCityList({
    super.key,
    required this.isDeparture,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = controller.state;

    final String modalTitle = isDeparture
        ? l10n.form_modalSelectAirportDeparture
        : l10n.form_modalSelectAirportArrival;

    final TextEditingController searchController = TextEditingController();

    return StatefulBuilder(
      builder: (context, modalSetState) {
        final filteredList = controller.FilteredCities(searchController.text);

        return Container(
          // Sử dụng rh để chiều cao ổn định theo tỷ lệ pixel chuẩn
          height: context.rh(650).clamp(500.0, 850.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.radius * 1.5),
            ),
          ),
          child: Column(
            children: [
              // 1. HANDLE BAR & TITLE
              Padding(
                padding: EdgeInsets.all(context.padding),
                child: Column(
                  children: [
                    Container(
                      height: context.rh(4),
                      width: context.rw(40),
                      // Cố định chiều rộng handle bar theo pixel scale
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(context.radius),
                      ),
                    ),
                    SizedBox(height: context.rh(12)),
                    Text(
                      modalTitle,
                      style: TextStyle(
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. SEARCH BOX
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.padding,
                  vertical: context.rh(4), // Thay h(0.5) bằng rh(4)
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: false,
                  onChanged: (_) => modalSetState(() {}),
                  style: TextStyle(fontSize: context.sp(15)),
                  decoration: InputDecoration(
                    hintText: l10n.form_labelSearchHint,
                    hintStyle: TextStyle(
                      fontSize: context.sp(14),
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                      size: context.icon(22),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF2F4F7),
                    // contentPadding dọc nên dùng rh
                    contentPadding: EdgeInsets.symmetric(
                      vertical: context.rh(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.radius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.rh(8)),

              // 3. CITY LIST
              Expanded(
                child: filteredList.isEmpty
                    ? _buildEmptyState(context, l10n)
                    : ListView.separated(
                        // Thêm padding dưới để tránh dính sát phím ảo/home bar máy thật
                        padding: EdgeInsets.only(bottom: context.rh(20)),
                        itemCount: filteredList.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          // Indent nên dùng rw để thẳng hàng với text
                          indent:
                              context.padding +
                              context.icon(24) +
                              context.rw(12),
                          endIndent: context.padding,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final isSelected = isDeparture
                              ? item.label == state.form.Departure
                              : item.label == state.form.Destination;

                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: context.padding,
                              vertical: context.rh(2), // Thay h(0.2) bằng rh(2)
                            ),
                            leading: Icon(
                              icon,
                              color: isSelected
                                  ? kPrimaryColor
                                  : Colors.blueGrey,
                              size: context.icon(22),
                            ),
                            title: Text(
                              "${item.label} (${item.value})",
                              style: TextStyle(
                                fontSize: context.sp(15),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? kPrimaryColor
                                    : const Color(0xFF263238),
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: kPrimaryColor,
                                    size: context.icon(20),
                                  )
                                : null,
                            onTap: () {
                              controller.selectCity(
                                isDeparture: isDeparture,
                                city: item,
                              );
                              Navigator.pop(context);
                            },
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

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: context.icon(50),
            color: Colors.grey,
          ),
          SizedBox(height: context.rh(12)),
          Text(
            "Không tìm thấy ga tàu",
            style: TextStyle(color: Colors.grey, fontSize: context.sp(14)),
          ),
        ],
      ),
    );
  }
}
