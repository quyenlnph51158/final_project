import 'package:final_project/core/data/model/extra_service_model.dart';
import 'package:final_project/core/design/shared/app_layout_spacing.dart';
import 'package:final_project/core/design/shared/app_style.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_screen/service_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';

class ExtraSection extends StatelessWidget {
  final List<ExtraServiceModel> ExtraService;

  const ExtraSection({super.key, required this.ExtraService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FlightLayoutSpacing.screenHorizontalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SharedAppLayoutSpacing.section,
          Center(
            child: Text(
              l10n.flight_extraServices,
              style: SharedAppStyle.titleSection(context),
            ),
          ),
          SharedAppLayoutSpacing.labelandCard,
          ...ExtraService.map((service) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: FlightLayoutSpacing.gapBetweenCards(context),
              ),
              child: ServiceCard(service: service),
            );
          }).toList(),
          SharedAppLayoutSpacing.footer,
        ],
      ),
    );
  }
}
