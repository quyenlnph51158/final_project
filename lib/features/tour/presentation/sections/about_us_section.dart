import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/image_link.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';
import '../widgets/about_us_item.dart';

class AboutUsSection extends StatelessWidget{
  const AboutUsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller=context.watch<TravelBookingController>();
    return Padding(
      padding: AppLayoutSpacing.aboutUsSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.home_aboutUsVibes,
            style: AppStyles.aboutUsVibe,
          ),
          Text(
            '${l10n.home_aboutUsTitleLine1}\n${l10n.home_aboutUsTitleLine2}',
            textAlign: TextAlign.center,
            style: AppStyles.aboutUsTitle,
          ),
          AppLayoutSpacing.labelandcontent,
          Padding(
            padding: AppLayoutSpacing.aboutUsDescription,
            child: Text(
              l10n.home_aboutUsDescription,
              textAlign: TextAlign.center,
              style: AppStyles.aboutUsdescription,
            ),
          ),
          AppLayoutSpacing.itemAndButtonAboutUs,
          AboutUsItem(
            icon: Icons.map_outlined,
            title: l10n.home_aboutUsGuideTitle,
            subtitle: l10n.home_aboutUsGuideSubtitle,
          ),
          AppLayoutSpacing.item,
          AboutUsItem(
            icon: Icons.track_changes_outlined,
            title:  l10n.home_aboutUsMissionTitle,
            subtitle:  l10n.home_aboutUsMissionSubtitle,
          ),
          AppLayoutSpacing.itemAndButtonAboutUs,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.scrollToTop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: AppLayoutSpacing.labelButtonAboutUs,
                shape: AppShape.aboutUsButton,
              ),
              child: Text(
                l10n.home_exploreButton,
                style: AppStyles.labelButtonAboutUs,
              ),
            ),
          ),
          AppLayoutSpacing.buttonAboutUsAndCoFounder,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    ImageLink.avatarCoFounder),
              ),
              AppLayoutSpacing.imageAndIformation,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.general_coFounderName,
                      style: AppStyles.nameCoFounder),
                  Text(l10n.general_coFounderRole, style: AppStyles.coFounderRole),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}