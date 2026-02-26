import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:flutter/material.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../../../../core/design/tour/app_styles.dart';

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
                  padding: AppLayoutSpacing.titleHeader,
                  child: Text(
                    '${l10n.header_titleLine1} \n'
                        '${l10n.header_titleLine2}',
                    style: AppStyles.titleHeader
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