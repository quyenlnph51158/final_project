import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';

import '../widgets/aboutUsItem.dart';

class AboutUsSection extends StatelessWidget{
  const AboutUsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.home_aboutUsVibes,
            style: TextStyle(
              fontFamily: 'GreatVibes',
              fontSize: 24,
              color: Color(0xFF00796B),
            ),
          ),
          Text(
            '${l10n.home_aboutUsTitleLine1}\n${l10n.home_aboutUsTitleLine2}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              l10n.home_aboutUsDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          AboutUsItem(
            icon: Icons.map_outlined,
            title: l10n.home_aboutUsGuideTitle,
            subtitle: l10n.home_aboutUsGuideSubtitle,
          ),
          const SizedBox(height: 16),
          AboutUsItem(
            icon: Icons.track_changes_outlined,
            title:  l10n.home_aboutUsMissionTitle,
            subtitle:  l10n.home_aboutUsMissionSubtitle,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.home_exploreSnackbar)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                l10n.home_exploreButton,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/tieuquynh/200/200'),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.general_coFounderName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(l10n.general_coFounderRole, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}