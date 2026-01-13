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
    final bool isFlight = state.selectedTab == TravelTab.flight;

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
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2.5)
                        )
                    ),
                    const SizedBox(height: 10),
                    Text(modalTitle,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Ô nhập tìm kiếm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    modalSetState(() {}); // Chỉ làm mới Modal này
                  },
                  decoration: InputDecoration(
                    hintText: l10n.form_labelSearchHint,
                    prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: kFormFieldBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
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
                        ? item.label == state.departure
                        : item.label == state.destination;

                    return ListTile(
                      leading: isFlight
                          ? Icon(icon, color: kPrimaryColor)
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: item.image != null
                            ? Image.network(
                          item.image!,
                          width: 35, height: 35, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.location_city, size: 35),
                        )
                            : const Icon(Icons.location_city, size: 35),
                      ),
                      title: Text(item.label),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: kPrimaryColor)
                          : null,
                      onTap: () {
                        controller.selectLocation(item, isDeparture);
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
}