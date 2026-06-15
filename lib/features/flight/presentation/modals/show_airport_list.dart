import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/flight_controller.dart';

class ShowAirportList extends StatefulWidget {
  final bool isDeparture;
  final IconData icon;
  final FlightController controller;

  const ShowAirportList({
    super.key,
    required this.isDeparture,
    required this.icon,
    required this.controller,
  });

  @override
  State<ShowAirportList> createState() => _ShowAirportListState();
}

class _ShowAirportListState extends State<ShowAirportList> {
  // Sử dụng một controller duy nhất
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = widget.controller.state;

    final String modalTitle = widget.isDeparture
        ? l10n.form_modalSelectAirportDeparture
        : l10n.form_modalSelectAirportArrival;

    // Lấy danh sách đã lọc dựa trên nội dung text hiện tại
    final filteredList = widget.controller.filteredAirports(_searchController.text);

    return Container(
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
              vertical: context.rh(4),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              // Gọi setState để rebuild lại widget này khi người dùng gõ
              onChanged: (value) {
                setState(() {});
              },
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

          // 3. AIRPORT LIST
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
              padding: EdgeInsets.only(bottom: context.rh(30)),
              itemCount: filteredList.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: context.padding + context.icon(24) + context.rw(12),
                endIndent: context.padding,
                color: Colors.grey.withOpacity(0.1),
              ),
              itemBuilder: (context, index) {
                final item = filteredList[index];

                // Kiểm tra xem sân bay này có đang được chọn không (dựa trên 'value' hoặc 'code' thường chính xác hơn 'label')
                final isSelected = widget.isDeparture
                    ? item.value == state.criteria.departureAirport.value
                    : item.value == state.criteria.destinationAirport.value;

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.padding,
                    vertical: context.rh(2),
                  ),
                  leading: Icon(
                    widget.icon,
                    color: isSelected ? kPrimaryColor : Colors.blueGrey,
                    size: context.icon(22),
                  ),
                  title: Text(
                    "${item.label} (${item.value})",
                    style: TextStyle(
                      fontSize: context.sp(15),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? kPrimaryColor : const Color(0xFF263238),
                    ),
                  ),
                  subtitle: item.airline != null ? Text(
                    item.airline!,
                    style: TextStyle(fontSize: context.sp(12), color: Colors.grey),
                  ) : null,
                  trailing: isSelected
                      ? Icon(
                    Icons.check_circle,
                    color: kPrimaryColor,
                    size: context.icon(20),
                  )
                      : null,
                  onTap: () {
                    widget.controller.selectAirport(
                      isDeparture: widget.isDeparture,
                      airport: item,
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
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.airplanemode_inactive,
            size: context.icon(50),
            color: Colors.grey[300],
          ),
          SizedBox(height: context.rh(12)),
          Text(
            "Không tìm thấy sân bay",
            style: TextStyle(color: Colors.grey, fontSize: context.sp(14)),
          ),
        ],
      ),
    );
  }
}