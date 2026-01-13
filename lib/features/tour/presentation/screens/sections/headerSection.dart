import 'package:flutter/material.dart';
import '../../../../../../core/constants/colors.dart';
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
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 20.0,
                right: 20.0,
              ),
              child: Text(
                '${l10n.header_titleLine1}\n${l10n.header_titleLine2}',
                style: const TextStyle(
                  color: kHeaderTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
