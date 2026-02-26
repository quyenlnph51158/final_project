import 'package:final_project/features/flight/presentation/widgets/service_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../app/l10n/app_localizations.dart';

class ExtraSection extends StatelessWidget{
  final List<Map<String,dynamic>> ExtraService;
  const ExtraSection({
    super.key,
    required this.ExtraService
  });
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.flight_extraServices,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...ExtraService.map((service) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ServiceCard(service: service,),
            );
          }).toList(),
        ],
      ),
    );
  }
}