import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:flutter/material.dart';
import 'package:final_project/shared/header/custom_app_bar.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../../../../core/design/shared/app_style.dart';
import '../../../../../core/design/tour/tour_styles.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(),
                Padding(
                  padding: TourLayoutSpacing.titleHeader(context),
                  child: Text(
                    '${l10n.header_titleLine1} \n'
                        '${l10n.header_titleLine2}',
                    style: SharedAppStyle.titleHeader(context)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}