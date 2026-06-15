import 'package:final_project/core/data/model/extra_service_model.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_screen/service_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart';

class ExtraSection extends StatelessWidget {
  final List<ExtraServiceModel> ExtraService;

  const ExtraSection({super.key, required this.ExtraService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.rh(32)),
          Center(
            child: Text(
              l10n.flight_extraServices,
              style: TextStyle(
                fontSize: context.sp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: context.rh(16)),
          ...ExtraService.map((service) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: context.rh(16.0),
              ),
              child: ServiceCard(service: service),
            );
          }).toList(),
          SizedBox(height: context.rh(48)),
        ],
      ),
    );
  }
}
