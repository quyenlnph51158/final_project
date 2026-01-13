import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../data/models/tour_detail.dart';

class ScheduleSection extends StatelessWidget{
  final TourDetail detail;
  const ScheduleSection({super.key,
    required this.detail,
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (detail.schedules == null || detail.schedules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.tour_detail_itinerary,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detail.schedules.length,
            itemBuilder: (context, index) {
              final schedule = detail.schedules[index];
              final parts = schedule.name.split(':');
              final dayName = parts[0];
              final briefInfo = parts.length > 1 ? parts[1].trim() : '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
                    leading: const Icon(Icons.circle, size: 12, color: kPrimaryColor),
                    title: Text(
                      dayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      briefInfo,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_up, color: Colors.black),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                        child: HtmlWidget(
                          schedule.description,
                          textStyle: const TextStyle(fontSize: 14.5, color: Colors.black87),
                          customStylesBuilder: (element) {
                            if (element.localName == 'p') {
                              return {'margin-bottom': '10px'};
                            }
                            if (element.localName == 'li') {
                              return {'margin-bottom': '8px'};
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}