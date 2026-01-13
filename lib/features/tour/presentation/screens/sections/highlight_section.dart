import 'package:final_project/features/tour/data/models/tour_detail.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HighlightSection extends StatelessWidget{
  final TourDetail detail;
  const HighlightSection({super.key,
    required this.detail
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (detail.extensions == null || detail.extensions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tour_detail_highlights,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detail.extensions.length,
            itemBuilder: (context, index) {
              final highlight = detail.extensions[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0, right: 10.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.teal,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        highlight,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}