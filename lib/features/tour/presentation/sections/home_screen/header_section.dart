import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../../app/l10n/app_localizations.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(),
            Padding(
              padding: AppLayoutSpacing.paddingAppbarAndTitle,
              child: Text(
                '${l10n.header_titleLine1}\n${l10n.header_titleLine2}',
                style: AppStyles.TravelingBookingHeaderTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
