import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/features/tour/data/models/tour_destination.dart';
import 'package:final_project/shared/widgets/drag_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart';

class LocationPickerSheet<T extends TourDestination>
    extends StatefulWidget {
  final String title;
  final List<T> tourDestinations;
  final String? selectedValue;
  final ValueChanged<T> onSelected;

  const LocationPickerSheet({
    super.key,
    required this.title,
    required this.tourDestinations,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<LocationPickerSheet<T>> createState() =>
      _LocationPickerSheetState<T>();
}

class _LocationPickerSheetState<T extends TourDestination>
    extends State<LocationPickerSheet<T>> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredLocations = widget.tourDestinations
        .where((e) => e.label
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()))
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // Thanh kéo (Handle) và Tiêu đề
          Padding(
            padding: EdgeInsets.all(context.rw(12)),
            child: Column(
              children: [
                const DragIndicator(),
                SizedBox(height: context.rh(8)),
                Text(widget.title,
                    style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
          // SEARCH
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.padding,
              vertical: context.rh(8),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.form_labelSearchHint,
                prefixIcon: AppIcons.iconSearchBox,
                filled: true,
                fillColor: kFormFieldBackground,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: kBorderColor)),
                contentPadding: EdgeInsets.symmetric(vertical: context.rh(15))
              ),
            ),
          ),

          // LIST
          Expanded(
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (_, index) {
                final item = filteredLocations[index];
                final isSelected =
                    item.label == widget.selectedValue;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: item.image != null? ClipRRect( // Nên bọc ClipRRect ở đây để ảnh và loading đều bo góc
                        borderRadius: BorderRadius.circular(8), // Hoặc dùng design system của bạn
                        child: Image.network(
                          item.image!,
                          width: context.rw(37),
                          height: context.rh(36),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            // SỬA TẠI ĐÂY: Dùng SizedBox thay vì Center đơn thuần
                            return SizedBox(
                              width: context.rw(37),
                              height: context.rh(36),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => SizedBox(
                            width: context.rw(37),
                            height: context.rh(36),
                            child: AppIcons.iconLocation,
                          ),
                        ),
                      )
                          : AppIcons.iconLocation,
                      title: Text(item.label),
                      trailing: isSelected ? AppIcons.iconCheck : null,
                      onTap: () {
                        widget.onSelected(item);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
