import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_dividers.dart';
import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/data/models/tour_destination.dart';
import 'package:final_project/shared/widgets/drag_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../app/l10n/app_localizations.dart';

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
            padding: AppLayoutSpacing.paddingHandleAndTitle,
            child: Column(
              children: [
                const DragIndicator(),
                AppLayoutSpacing.handleAndTitle,
                Text(widget.title,
                    style: AppStyles.titleShowList),
              ],
            ),
          ),
          // SEARCH
          Padding(
            padding: AppLayoutSpacing.paddingSearchBox,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.form_labelSearchHint,
                prefixIcon: AppIcons.iconSearchBox,
                filled: true,
                fillColor: kFormFieldBackground,
                border: AppShape.borderSearchBox,
                contentPadding: AppLayoutSpacing.paddingContentSearchBox
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
                      leading: item.image != null
                        ? Image.network(
                        item.image!,
                        width: AppSizes.wImageLocation,
                        height: AppSizes.hImageLocation,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (_, __, ___) =>
                        AppIcons.iconLocation,
                      )
                          : AppIcons.iconLocation,
                      title: Text(item.label),
                      trailing: isSelected ? AppIcons.iconCheck : null,
                      onTap: () {
                        widget.onSelected(item);
                        Navigator.pop(context);
                      },
                    ),
                    AppDividers.AirportAndStationName
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
