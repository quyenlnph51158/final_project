import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/features/tour/data/models/tour_detail.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_layout.dart';

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
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tour_detail_highlights,
            style: TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: context.rh(16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detail.extensions.map((highlight) {
              return Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: context.rh(2),
                        right: context.rw(10),
                      ),
                      child: AppIcons.check_circle,
                    ),
                    Expanded(
                      child: Text(
                        highlight,
                        style: TextStyle(fontSize: context.sp(16), color: Colors.black87, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}