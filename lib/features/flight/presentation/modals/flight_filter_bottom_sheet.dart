import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart'; // Giả định chứa kPrimaryColor
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_style.dart';
import 'package:provider/provider.dart';
import '../controller/flight_controller.dart';

void showFlightFilter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FlightFilterBottomSheet(),
  );
}

class FlightFilterBottomSheet extends StatefulWidget {
  const FlightFilterBottomSheet({super.key});

  @override
  State<FlightFilterBottomSheet> createState() => _FlightFilterBottomSheetState();
}

class _FlightFilterBottomSheetState extends State<FlightFilterBottomSheet> {
  // Trạng thái giả lập (Nên đưa vào một FilterModel trong thực tế)
  final Map<String, String> _airlines = {"Vietnam Airlines": "Vietnam Airlines", "Vietjet Air": "Vietjet Air", "Bamboo Airways": "Bamboo Airways"};
  final Map<String, int> _stops = {"Bay thẳng": 0, "1 Chặng dừng": 1, "2 Chặng dừng": 2};
  final Map<String, String> _timeRanges = {"Sớm (0 AM - 5:59 AM)": "Sớm", "Sáng (6 AM - 11:59 AM)": "Sáng", "Trưa (12 PM - 5:59 PM)": "Trưa", "Tối (6 PM - 11:59 PM)": "Tối"};

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FlightController>();
    final filter = controller.state.filter;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // 1. Header
          _buildHeader(context),

          // 2. Nội dung cuộn
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, "Hãng hàng không"),
                  ..._airlines.entries.map((e) => _buildCheckboxRow(title: e.key, isSelected: filter.selectedAirlineSystem.contains(e.value), onToggle: () => controller.toggleAirlineSystem(e.value))),

                  const SizedBox(height: 24),
                  _buildSectionTitle(context, "Chặng dừng"),
                  ..._stops.entries.map((e) => _buildCheckboxRow(title: e.key, isSelected: filter.selectedStopPoint.contains(e.value), onToggle: () => controller.toggleStopPoint(e.value))),

                  const SizedBox(height: 24),
                  _buildSectionTitle(context, "Giờ khởi hành"),
                  ..._timeRanges.entries.map((e) => _buildCheckboxRow(title: e.key, isSelected: filter.selectedTimeDeparture.contains(e.value), onToggle: () => controller.toggleTimeDeparture(e.value))),
                ],
              ),
            ),
          ),

          // 3. Nút Áp dụng
          _buildApplyButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, size: 20),
          const SizedBox(width: 12),
          Text(
            'Lọc',
            style: FlightStyle.sectionTitleBold(context).copyWith(fontSize: 18),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: FlightStyle.sectionTitleBold(context).copyWith(
          color: const Color(0xFF01171B),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({ required String title, required bool isSelected, required VoidCallback onToggle}) {

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 24, width: 24,
              child: Checkbox(
                value: isSelected,
                activeColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (_) => onToggle(),
              ),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 14, color: kTextColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            context.read<FlightController>().applyFilter();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006677), // Màu Teal đậm trong ảnh
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Áp dụng',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}