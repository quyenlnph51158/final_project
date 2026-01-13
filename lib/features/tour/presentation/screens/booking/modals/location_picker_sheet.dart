import 'package:final_project/features/tour/data/models/tour_destination.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';

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
    final filteredLocations = widget.tourDestinations
        .where((e) => e.label
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()))
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon:
                const Icon(Icons.search, color: kPrimaryColor),
                filled: true,
                fillColor: kFormFieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
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

                return ListTile(
                  leading: item.image != null
                      ? Image.network(
                    item.image!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.location_city),
                  )
                      : const Icon(Icons.location_city),
                  title: Text(item.label),
                  trailing: isSelected
                      ? const Icon(Icons.check,
                      color: kPrimaryColor)
                      : null,
                  onTap: () {
                    widget.onSelected(item);
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
}
